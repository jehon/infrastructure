
from typing import Optional

import jehon.display as jdi
from .shell import run

def ssh(host: str, cmd: list[str],
            title: str = "ssh",
            user: Optional[str] = None,
            password: Optional[str] = None
        ):

    cmdline: list[str] = []
    env: dict[str, str]	 = {}

    if password:
        cmdline += [ "sshpass", "-e" ]
        env["SSHPASS"] = password

    cmdline += [ "ssh", host ]

    if user:
        cmdline += [ "-l", user ]

    cmdline += cmd

    with jdi.header(title):
        run(cmdline,env=env)
