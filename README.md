henrikp
==============

My custom gentoo overlay, version bumps/fixes get removed if they get added to the main repository.

![Overlay QA](https://github.com/henrikp/gentoo-overlay/workflows/Overlay%20QA/badge.svg?branch=master)

Legend | Description
------- | -----------
:pencil2: | In progress, don't expect it to work at all :)
:mailbox_with_mail: | Finished, submitted.
:green_book: | Finished.

Currently in this overlay
-------------------------

Package | Name | [GURU?](https://wiki.gentoo.org/wiki/Project:GURU) | Description
------- | ---- | ----- | -----------
[:mailbox_with_mail:]app-editors/kitscenarist | KIT Scenarist | * | new, https://kitscenarist.ru/en/ 
[:pencil2:]dev-cpp/openframeworks | openFrameworks || new, https://openframeworks.cc/ 
[:green_book:]dev-libs/libtess2 | Libtess2 || new, https://github.com/memononen/libtess2 
[:green_book:]games-util/evtest-qt | QT GUI + evtest || new, https://github.com/Grumbel/evtest-qt
[:green_book:]games-utils/sdl-jstest | SDL 1 & 2 joystick testing || new, https://gitlab.com/sdl-jstest/sdl-jstest
[:green_book:]media-sound/vban | VBAN linux tools || new, https://github.com/quiniouben/vban
[:pencil2:]media-sound/vban-manager | VBAN web interface || new, https://github.com/VBAN-manager/VBAN-manager 
[:mailbox_with_mail:]media-video/droidcam | DroidCam || new, https://www.dev47apps.com/
[:green_book:]media-video/shotcut | Shotcut || 20.07.11 version bump
[:green_book:]sys-apps/rogdrv | ASUS ROG mouse utility |*| new, https://github.com/kyokenn/rogdrv
[:green_book:]sys-apps/qjournalctl | Journalctl log Qt viewer |*| new, https://github.com/pentix/qjournalctl
[:mailbox_with_mail:]sci-mathematics/wxmaxima | wxMaxima || 20.07.0 version bump, move to 3.0-gtk3

Adding this overlay:
> `layman -o https://raw.githubusercontent.com/henrikp/gentoo-overlay/master/repositories.xml
-f -a henrikp`
