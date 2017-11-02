/*!--------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
(function(){var e=["vs/workbench/parts/terminal/node/terminalProcess","require","exports","child_process","os","path","node-pty"];define(e[0],function(s){for(var n=[],o=0,t=s.length;o<t;o++)n[o]=e[s[o]];return n}([1,2,3,4,5,6]),function(e,s,n,o,t,r){"use strict";function c(){P&&clearTimeout(P),P=setTimeout(function(){"win32"===process.platform?n.execFile("taskkill.exe",["/T","/F","/PID",Y.pid.toString()]).on("close",function(){process.exit(d)}):(Y.kill(),process.exit(d))},250)}function i(){process.send({type:"title",content:Y.process}),L=Y.process}Object.defineProperty(s,"__esModule",{value:!0});var p;p="win32"===o.platform()?t.basename(process.env.PTYSHELL):"xterm-256color";var a=process.env.PTYSHELL,u=function(){if(process.env.PTYSHELLCMDLINE)return process.env.PTYSHELLCMDLINE;for(var e=[],s=0;process.env["PTYSHELLARG"+s];)e.push(process.env["PTYSHELLARG"+s]),s++;return e}(),l=process.env.PTYCWD,v=process.env.PTYCOLS,f=process.env.PTYROWS,L="";!function(e){setInterval(function(){try{process.kill(e,0)}catch(e){process.exit()}},5e3)}(process.env.PTYPID),function(){["AMD_ENTRYPOINT","ELECTRON_RUN_AS_NODE","PTYCWD","PTYPID","PTYSHELL","PTYCOLS","PTYROWS","PTYSHELLCMDLINE"].forEach(function(e){process.env[e]&&delete process.env[e]});for(;process.env.PTYSHELLARG0;)delete process.env.PTYSHELLARG0}();var T={name:p,cwd:l};v&&f&&(T.cols=parseInt(v,10),T.rows=parseInt(f,10));var P,d,Y=r.fork(a,u,T);Y.on("data",function(e){process.send({type:"data",content:e}),P&&(clearTimeout(P),c())}),Y.on("exit",function(e){d=e,c()}),process.on("message",function(e){"input"===e.event?Y.write(e.data):"resize"===e.event?Y.resize(Math.max(e.cols,1),Math.max(e.rows,1)):"shutdown"===e.event&&c()}),process.send({type:"pid",content:Y.pid}),i(),setInterval(function(){L!==Y.process&&i()},200)})}).call(this);
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/b813d12980308015bcd2b3a2f6efa5c810c33ba5/core/vs/workbench/parts/terminal/node/terminalProcess.js.map
