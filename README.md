gentoo-overlay
==============

My custom gentoo overlay!

Currently in this overlay
-------------------------
    app-text/zeal (~x86, ~amd64)

Adding this overlay
-------------------
Install [Layman](http://layman.sourceforge.net/):

    layman -o https://raw.githubusercontent.com/henrikp/gentoo-overlay/master/repository.xml -f -a henrikp

For app-text/zeal, you will also need to enable the Qt overlay as well:

    layman -a qt
