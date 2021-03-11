# AriaNg
[![License](https://img.shields.io/github/license/mayswind/AriaNg.svg?style=flat)](https://github.com/mayswind/AriaNg/blob/master/LICENSE)
[![Lastest Build](https://img.shields.io/circleci/project/github/mayswind/AriaNg.svg?style=flat)](https://circleci.com/gh/mayswind/AriaNg/tree/master)
[![Lastest Release](https://img.shields.io/github/release/mayswind/AriaNg.svg?style=flat)](https://github.com/mayswind/AriaNg/releases)

## Introduction
[AriaNg](https://github.com/mayswind/AriaNg) is a modern web frontend making [aria2](https://github.com/aria2/aria2) easier to use. AriaNg is written in pure html & javascript, thus it does not need any compilers or runtime environment. You can just put AriaNg in your web server and open it in your browser. AriaNg uses responsive layout, and supports any desktop or mobile devices.

## Usage
``` sh
docker run -d --name ariang --restart=unless-stopped -p 8080:8080 leonismoe/ariang
```

## Features
1. Pure Html & Javascript, no runtime required
2. Responsive design, supporting desktop and mobile devices
3. User-friendly interface
    * Sort tasks (by name, size, progress, remaining time, download speed, etc.), files, bittorrent peers
    * Search tasks
    * Retry tasks
    * Adjust task order by dragging
    * More information of tasks (health percentage, client information of bt peers, etc.)
    * Filter files by specified file types (videos, audios, pictures, documents, applications, archives, etc.) or file extensions
    * Tree view for multi-directory task
    * Download / upload speed chart for aria2 or single task
    * Full support for aria2 settings
4. Dark theme
5. Url command line api support
6. Download finished notification
7. Multi-languages support
8. Multi aria2 RPC host support
9. Exporting and Importing settings support
10. Less bandwidth usage, only requesting incremental data

## Screenshots
#### Desktop
![AriaNg](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/desktop.png)
#### Mobile Device
![AriaNg](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/mobile.png)

## Tiny httpd references
* https://www.reddit.com/r/docker/comments/57tbbw/challenge_rdocker_create_the_smallest_http_server/
* https://github.com/sseemayer/mini-helloworld-httpd
* https://github.com/piccaso/docker-asmttpd
* https://blog.netherlabs.nl/articles/2009/01/18/the-ultimate-so_linger-page-or-why-is-my-tcp-not-reliable
