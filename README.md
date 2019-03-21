# smarthome-docker
Einige hilfreiche Docker-Images für mein Samrthome.

*Some useful docker images for my smarthome.*

## ToDo:
* Image verkleinern (Alpine als Basis?) / reduze image size (use alpine?)
* SCM-Versionen in Metadaten aufnehmen / include SCM-Versions in metadata

## builder
Buildumgebung für einige Images. Imagegröße spielt hier für mich keine Rolle.

*Build environment for some of the images. Imagesize is not my focus in this case.*

## knxd
Makefile ist für den build ohne systemd gepatched.

*Makefile patched for build without systemd.*

## fhem
Änderungen zur Standard-Installation:
* fhem.cfg unter ~~
* log nach STDIO (Docker-like)
* Log im FHEMWEB ausgebeldet
* /op/fhem/log und /opt/fhem/www/gplot ebenfalls nach ~ verschoben
* fhem.cfg nofork ergänzt mit Docker unnötig