gentoo-overlay
==============

My custom gentoo overlay!

Adding this overlay
-------------------
Install [Layman](http://layman.sourceforge.net/):

    layman -o https://raw.githubusercontent.com/henrikp/gentoo-overlay/master/repository.xml -f -a henrikp

You will also need to enable the Qt overlay as well:

    layman -a qt