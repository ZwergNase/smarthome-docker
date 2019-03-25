# smarthome-docker
Einige hilfreiche Docker-Images für mein Smarthome.
*Some useful docker images for my smarthome.*

## ToDo:
* Image verkleinern (Alpine als Basis?) / *reduze image size (use alpine?)*
* SCM-Versionen in Metadaten aufnehmen / *include SCM-Versions in metadata*
* Orchestrierung / *orchestration*

## builder
Buildumgebung für einige Images. Imagegröße spielt hier für mich keine Rolle.
*Build environment for some of the images. Imagesize is not my focus in this case.*

## knxd
Makefile ist für den build ohne systemd gepatched.
*Makefile patched for build without systemd.*
### ToDo:
* ohne --network=host / *no --network=host*
* Patch "ohne systemd" bisher nur hack / *patch "w/o systemd" just a hack so far*

## fhem
Änderungen zur Standard-Installation:
* fhem.cfg unter ~ / *fhem.cfg in ~*
* log nach STDIO (Docker-like) / *log to STDIO (docker-like)*
* Log im FHEMWEB ausgebeldet / *log in FHEMWEB removed*
* /op/fhem/log und /opt/fhem/www/gplot ebenfalls nach ~ verschoben / */opt/fhem/log and /opt/fhem/www/gplot moved to ~aswell*
* nofork=1 in fhem.cfg, denn fhem ist einziger Prozess im Container / *nofork=1 in fhem.cfg, because fhem is process of its own within the container*