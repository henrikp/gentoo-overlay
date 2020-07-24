henrikp
==============

My custom gentoo overlay! To avoid clutter, packages here get removed if they get added to the main repository.

Legend | Description
------- | -----------
:pencil2: | In progress, don't expect it to work at all :)
:mailbox_with_mail: | Finished, submitted.
:green_book: | Finished.

Currently in this overlay
-------------------------

Package | Description
------- | -----------
[:mailbox_with_mail:]app-editors/kitscenarist | new, https://kitscenarist.ru/en/
[:pencil2:]dev-cpp/openFrameworks | new, https://openframeworks.cc/
[:green_book:]dev-libs/libtess2 | new, https://github.com/memononen/libtess2 
[:pencil2:]games-board/chessx | 1.5.4 version bump
[:pencil2:]media-sound/audacity | 2.4.2 version bump
[:mailbox_with_mail:]media-video/droidcam | new, https://www.dev47apps.com/
[:green_book:]media-video/shotcut | 20.07.11 version bump
[:green_book:]sys-apps/rogdrv | new, https://github.com/kyokenn/rogdrv


Adding this overlay:
> `layman -o https://raw.githubusercontent.com/henrikp/gentoo-overlay/master/repositories.xml
-f -a henrikp`
