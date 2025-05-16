#!/usr/bin/env python3

import json
import os
import argparse
import sys


class HyprLandHelper:

    def __init__(self):
        self.monitors = []
        self.update()

    def update(self):
        self.monitors = self.get_monitors()

    def notify(self, msg):
        os.system(f'hyprctl notify -1 4000 "rgb(ff1ea3)" "{msg}" ')

    def get_monitors(self):
        stream = os.popen("hyprctl monitors all -j")
        return json.loads(stream.read())

    def show_monitors(self):
        for monitor in self.monitors:
            print(f"ID:  {monitor['id']} {monitor['name']}", end="\t")
            print(f"Desc: {monitor['description']}", end="\t")
            print("Disabled:", monitor["disabled"])

    def notify_monitors(self):
        msg = ""
        for monitor in self.monitors:
            if monitor["disabled"]:
                continue
            msg = msg + f"ID: {monitor['id']} {monitor['description']}\n"
        self.notify(msg)

    def disable_monitor(self, monitor_id):
        mon = self.monitors[monitor_id]
        cmd = f"hyprctl keyword monitor {mon['name']}, disable >/dev/null"
        os.system(cmd)
        self.update()

    def enable_monitor(self, monitor_id):
        mon = self.monitors[monitor_id]
        # This commnand produce an error due to missing resolution and offset
        cmd = f"hyprctl keyword monitor {mon['name']}, enable > /dev/null"
        os.system(cmd)
        self.update()

    def toggle_main_monitor(self):
        # main is always 0
        self.toggle_monitor(0)

    def toggle_monitor(self, monitor_id):
        mon = self.monitors[monitor_id]
        if mon["disabled"]:
            self.enable_monitor(monitor_id)
        else:
            self.disable_monitor(monitor_id)

    def toggle_externals(self):
        for mon in self.monitors[1:]:
            if mon["disabled"]:
                self.enable_monitor(mon["id"])
            else:
                self.disable_monitor(mon["id"])


def run():
    parser = argparse.ArgumentParser(
        description="Helper script to manage Hyprland monitors."
    )
    parser.add_argument(
        "-s",
        "--status",
        action="store_true",
        help="Show the current monitor status without performing any actions.",
    )
    parser.add_argument(
        "-ti",
        "--toggle-main",
        action="store_true",
        help="Toggle the state of the main monitor (ID 0).",
    )
    parser.add_argument(
        "-te",
        "--toggle-externals",
        action="store_true",
        help="Toggle the state of all external monitors (IDs > 0).",
    )
    parser.add_argument(
        "-e",
        "--enable",
        metavar="ID",
        type=int,
        nargs="+",
        help="Enable monitor(s) by ID. Can specify multiple IDs.",
    )
    parser.add_argument(
        "-d",
        "--disable",
        metavar="ID",
        type=int,
        nargs="+",
        help="Disable monitor(s) by ID. Can specify multiple IDs.",
    )
    parser.add_argument(
        "-t",
        "--toggle",
        metavar="ID",
        type=int,
        nargs="+",
        help="Toggle the state of monitor(s) by ID. Can specify multiple IDs.",
    )

    args = parser.parse_args()
    hh = HyprLandHelper()

    # Determine if any action arguments were provided
    perform_actions = (
        args.toggle_main
        or args.toggle_externals
        or args.enable is not None
        or args.disable is not None
        or args.toggle is not None
    )

    # If only -s or no arguments were provided, just show status and exit
    if args.status and not perform_actions:
        print("--- Current Hyprland Monitors Status ---")
        hh.show_monitors()
        print("----------------------------------------")
        sys.exit(0)

    # If no arguments were provided at all (covers the base case)
    if len(sys.argv) == 1:
        print("--- Current Hyprland Monitors Status ---")
        hh.show_monitors()
        print("----------------------------------------")
        sys.exit(0)

    # If we reach here, it means action arguments were provided (potentially with -s)
    # Perform actions based on arguments. Order matters!
    # Toggle main/externals first, then specific enables/disables/toggles.
    # Specific toggles are handled last to ensure a clean final state if combined
    # with enable/disable on the same monitor in one command.

    if args.toggle_main:
        hh.toggle_main_monitor()

    if args.toggle_externals:
        hh.toggle_externals()

    # Process enables and disables
    if args.enable:
        for monitor_id in args.enable:
            hh.enable_monitor(monitor_id)

    if args.disable:
        for monitor_id in args.disable:
            hh.disable_monitor(monitor_id)

    # Process specific toggles
    if args.toggle:
        for monitor_id in args.toggle:
            hh.toggle_monitor(monitor_id)

    # After performing actions, show the updated state
    print("\n--- Final Hyprland Monitors State ---")
    hh.show_monitors()
    hh.notify_monitors()
    print("-------------------------------------")


if __name__ == "__main__":
    run()
