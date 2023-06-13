#!/usr/bin/env python3

import os
import socket
import sys
from threading import Event
import time

from stem.control import Controller, EventType, State
from stem.socket import ControlSocketFile

THROTTLE_COUNT = 5
TOR_SOCKET = '/run/tor/control'
TELEGRAF_ENDPOINT = ('127.0.0.1', 9052)

def time_ns():
    return int(time.time() * 1e9)

def get_telegraf_socket():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(TELEGRAF_ENDPOINT)
    return sock

def main():
    def bw_handler(e):
        nonlocal count
        if sock is None:
            return
        count = (count + 1) % THROTTLE_COUNT
        if count != 0:
            return
        out = 'tor bw_read={}i,bw_written={}i {}\n'.format(e.read, e.written, time_ns())
        try:
            sock.sendall(out.encode('utf-8'))
        except Exception:
            event.set()
    def status(controller, state, timestamp):
        if state == State.CLOSED:
            event.set()
    event = Event()
    csf = ControlSocketFile(TOR_SOCKET, connect=False)
    controller = Controller(csf)
    controller.add_status_listener(status)
    controller.add_event_listener(bw_handler, EventType.BW)
    sock = None
    while True:
        count = 0
        event.clear()
        try:
            sock = get_telegraf_socket()
            if not controller.is_alive():
                controller.reconnect()
        except Exception:
            pass
        else:
            event.wait()
        if sock is not None:
            sock.close()
            sock = None
        time.sleep(15)
    sys.exit(1)

if __name__ == '__main__':
    main()
