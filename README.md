# SilkSpectre

**One goal**: watch item's sale for availability, specifically for **Playstation 5
availability** as configured by the application right now.

The application at this moment watches for Canadian websites of Amazon, BestBuy,
EBGames and Walmart. When availability is detected, a text notification is sent
to pre-configured number using Twilio REST API. 

Configuration should be stored in the *app.config* file, as showed by the
example file *app.config.example*. Copy the latter, replace values and rename
the file. 

The [prerender](https://github.com/prerender/prerender-node) node web 
middleware should be ran as well. That is to render 100% websites that requires
Javascript to generate their HTML DOM. Install node and execute:

```
cd SilkSpectre
npm install 
node .\prerender\prerender.js
```

The `continually.ps` script is provided as a replacement of the not-so-great
Microsoft Windows Scheduler. This thing is hard to configure, might not work,
and doesn't provide nice traces of the application's execution. All things 
that are included in the provided script: it just works (with PowerShell, 
 that is -- if you are on a \*nix platform, you can't complain with `cron`).

**Now we just need to get a PlayStation 5 using this program.**

# Known bugs

## Website timeout

A website timeout will result in a successful notification. I need to  learn
more Haskell, especially error management, before I can fix this. :X

# Specs

```
yyyyyy xxxxxx                  
 yyyyyy xxxxxx                 ------------------------------------------
  yyyyyy xxxxxx                Project: SilkSpectre (1 branch)
   yyyyyy xxxxxx               HEAD: 3847897 (main, origin/main)
    yyyyyy xxxxxx yyyyyyyyyy   
     yyyyyy xxxxxx yyyyyyyyy   Languages: Haskell (98.3 %) JavaScript (1.7 %)
      yyyyyy xxxxxx            Dependencies: 1 (npm)
     yyyyyy xxxxxxxx yyyyyyy   Author: 100% Jimmy Royer 6
    yyyyyy xxxxxxxxxx yyyyyy   
   yyyyyy xxxxxxxxxxxx         Repo: git@github.com:jimleroyer/SilkSpectre.git
  yyyyyy xxxxxx  xxxxxx        Commits: 6
 yyyyyy xxxxxx    xxxxxx       Lines of code: 181
yyyyyy xxxxxx      xxxxxx      Size: 2.66 KiB (23 files)
                               License: MIT

===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 Cabal                   1           99           88            5            6
 Haskell                 8          262          178           36           48
 JavaScript              1            3            3            0            0
 JSON                    2         1028         1028            0            0
 Markdown                2           73            0           59           14
 PowerShell              1           88           65           11           12
 YAML                    3          157           70           66           21
===============================================================================
 Total                  18         1710         1432          177          101
===============================================================================
```
