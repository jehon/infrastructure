# Systemd

https://www.freedesktop.org/software/systemd/man/systemd.service.html
https://www.freedesktop.org/software/systemd/man/systemd.unit.html
https://fedoramagazine.org/systemd-template-unit-files/

## Loops

systemd-analyze verify default.target

## No login?

"System is booting up. Unprivileged users are not permitted to log in yet. Please come back later. For technical details, see pam_nologin(8)."

/run/nologin
created by: systemd-tmpfiles-setup.service
removed by: systemd-user-sessions.service

Thanks to https://unix.stackexchange.com/a/487937/240487

# Curl

curl -fsSL

- f: Fail silently (no output)
- s: --silent
- S: --show-error
- L: --location (follow Location header's)
