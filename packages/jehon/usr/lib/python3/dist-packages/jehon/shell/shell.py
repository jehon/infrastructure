
import subprocess
import sys

def run(cmd: list[str], **kwargs):
    """Run a script and send back all output
    """

    with subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True, universal_newlines=True, **kwargs) as proc:
        if proc.stdout is not None:
            for stdout_line in proc.stdout:
                sys.stdout.write(stdout_line)
                sys.stdout.flush()

        return proc.wait()
