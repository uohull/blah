(function(){var GBS_HOST = "http://books.google.com/";var GBS_LANG = "en";var h,l=this;function m(){}
function n(a){var b=typeof a;if("object"==b)if(a){if(a instanceof Array)return"array";if(a instanceof Object)return b;var c=Object.prototype.toString.call(a);if("[object Window]"==c)return"object";if("[object Array]"==c||"number"==typeof a.length&&"undefined"!=typeof a.splice&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("splice"))return"array";if("[object Function]"==c||"undefined"!=typeof a.call&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("call"))return"function"}else return"null";else if("function"==
b&&"undefined"==typeof a.call)return"object";return b}function r(a){return"array"==n(a)}function s(a){var b=n(a);return"array"==b||"object"==b&&"number"==typeof a.length}function t(a){return"string"==typeof a}function aa(a){var b=typeof a;return"object"==b&&null!=a||"function"==b}var v="closure_uid_"+(1E9*Math.random()>>>0),ba=0;function ca(a,b,c){return a.call.apply(a.bind,arguments)}
function da(a,b,c){if(!a)throw Error();if(2<arguments.length){var d=Array.prototype.slice.call(arguments,2);return function(){var c=Array.prototype.slice.call(arguments);Array.prototype.unshift.apply(c,d);return a.apply(b,c)}}return function(){return a.apply(b,arguments)}}function w(a,b,c){w=Function.prototype.bind&&-1!=Function.prototype.bind.toString().indexOf("native code")?ca:da;return w.apply(null,arguments)}
function x(a,b){var c=Array.prototype.slice.call(arguments,1);return function(){var b=c.slice();b.push.apply(b,arguments);return a.apply(this,b)}}var ea=Date.now||function(){return+new Date};function y(a,b){var c=a.split("."),d=l;c[0]in d||!d.execScript||d.execScript("var "+c[0]);for(var e;c.length&&(e=c.shift());)c.length||void 0===b?d=d[e]?d[e]:d[e]={}:d[e]=b}function z(a,b){function c(){}c.prototype=b.prototype;a.O=b.prototype;a.prototype=new c};function A(a){Error.captureStackTrace?Error.captureStackTrace(this,A):this.stack=Error().stack||"";a&&(this.message=String(a))}z(A,Error);A.prototype.name="CustomError";function fa(a,b){for(var c=a.split("%s"),d="",e=Array.prototype.slice.call(arguments,1);e.length&&1<c.length;)d+=c.shift()+e.shift();return d+c.join("%s")}function ga(a){if(!ha.test(a))return a;-1!=a.indexOf("&")&&(a=a.replace(ia,"&amp;"));-1!=a.indexOf("<")&&(a=a.replace(ja,"&lt;"));-1!=a.indexOf(">")&&(a=a.replace(ka,"&gt;"));-1!=a.indexOf('"')&&(a=a.replace(la,"&quot;"));return a}var ia=/&/g,ja=/</g,ka=/>/g,la=/\"/g,ha=/[&<>\"]/;Math.random();
function ma(a){return String(a).replace(/\-([a-z])/g,function(a,c){return c.toUpperCase()})}function na(a){var b=t(void 0)?"undefined".replace(/([-()\[\]{}+?*.$\^|,:#<!\\])/g,"\\$1").replace(/\x08/g,"\\x08"):"\\s";return a.replace(RegExp("(^"+(b?"|["+b+"]+":"")+")([a-z])","g"),function(a,b,e){return b+e.toUpperCase()})};var B=Array.prototype,oa=B.indexOf?function(a,b,c){return B.indexOf.call(a,b,c)}:function(a,b,c){c=null==c?0:0>c?Math.max(0,a.length+c):c;if(t(a))return t(b)&&1==b.length?a.indexOf(b,c):-1;for(;c<a.length;c++)if(c in a&&a[c]===b)return c;return-1},pa=B.forEach?function(a,b,c){B.forEach.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=t(a)?a.split(""):a,f=0;f<d;f++)f in e&&b.call(c,e[f],f,a)},qa=B.some?function(a,b,c){return B.some.call(a,b,c)}:function(a,b,c){for(var d=a.length,e=t(a)?a.split(""):
a,f=0;f<d;f++)if(f in e&&b.call(c,e[f],f,a))return!0;return!1};function ra(a){return B.concat.apply(B,arguments)}function C(a){var b=a.length;if(0<b){for(var c=Array(b),d=0;d<b;d++)c[d]=a[d];return c}return[]}function sa(a,b,c){return 2>=arguments.length?B.slice.call(a,b):B.slice.call(a,b,c)};function ta(a){return function(){throw a;}};function D(a,b){this.x=void 0!==a?a:0;this.y=void 0!==b?b:0}D.prototype.p=function(){return new D(this.x,this.y)};D.prototype.floor=function(){this.x=Math.floor(this.x);this.y=Math.floor(this.y);return this};D.prototype.round=function(){this.x=Math.round(this.x);this.y=Math.round(this.y);return this};function E(a,b){this.width=a;this.height=b}E.prototype.p=function(){return new E(this.width,this.height)};E.prototype.floor=function(){this.width=Math.floor(this.width);this.height=Math.floor(this.height);return this};E.prototype.round=function(){this.width=Math.round(this.width);this.height=Math.round(this.height);return this};function ua(a,b){for(var c in a)b.call(void 0,a[c],c,a)}function wa(a){var b=[],c=0,d;for(d in a)b[c++]=a[d];return b}function xa(a){var b=[],c=0,d;for(d in a)b[c++]=d;return b}var ya="constructor hasOwnProperty isPrototypeOf propertyIsEnumerable toLocaleString toString valueOf".split(" ");function za(a,b){for(var c,d,e=1;e<arguments.length;e++){d=arguments[e];for(c in d)a[c]=d[c];for(var f=0;f<ya.length;f++)c=ya[f],Object.prototype.hasOwnProperty.call(d,c)&&(a[c]=d[c])}};var F,G,Aa,Ba,Ca;function Da(){return l.navigator?l.navigator.userAgent:null}function Ea(){return l.navigator}Ba=Aa=G=F=!1;var H;if(H=Da()){var Fa=Ea();F=0==H.lastIndexOf("Opera",0);G=!F&&(-1!=H.indexOf("MSIE")||-1!=H.indexOf("Trident"));Aa=!F&&-1!=H.indexOf("WebKit");Ba=!F&&!Aa&&!G&&"Gecko"==Fa.product}var Ga=F,I=G,J=Ba,K=Aa,Ha=Ea();Ca=-1!=(Ha&&Ha.platform||"").indexOf("Mac");var Ia=!!Ea()&&-1!=(Ea().appVersion||"").indexOf("X11");function Ja(){var a=l.document;return a?a.documentMode:void 0}var Ka;
t:{var La="",L;if(Ga&&l.opera)var Ma=l.opera.version,La="function"==typeof Ma?Ma():Ma;else if(J?L=/rv\:([^\);]+)(\)|;)/:I?L=/\b(?:MSIE|rv)[: ]([^\);]+)(\)|;)/:K&&(L=/WebKit\/(\S+)/),L)var Na=L.exec(Da()),La=Na?Na[1]:"";if(I){var Oa=Ja();if(Oa>parseFloat(La)){Ka=String(Oa);break t}}Ka=La}var Pa=Ka,Qa={};
function M(a){var b;if(!(b=Qa[a])){b=0;for(var c=String(Pa).replace(/^[\s\xa0]+|[\s\xa0]+$/g,"").split("."),d=String(a).replace(/^[\s\xa0]+|[\s\xa0]+$/g,"").split("."),e=Math.max(c.length,d.length),f=0;0==b&&f<e;f++){var g=c[f]||"",k=d[f]||"",p=RegExp("(\\d*)(\\D*)","g"),va=RegExp("(\\d*)(\\D*)","g");do{var u=p.exec(g)||["","",""],q=va.exec(k)||["","",""];if(0==u[0].length&&0==q[0].length)break;b=((0==u[1].length?0:parseInt(u[1],10))<(0==q[1].length?0:parseInt(q[1],10))?-1:(0==u[1].length?0:parseInt(u[1],
10))>(0==q[1].length?0:parseInt(q[1],10))?1:0)||((0==u[2].length)<(0==q[2].length)?-1:(0==u[2].length)>(0==q[2].length)?1:0)||(u[2]<q[2]?-1:u[2]>q[2]?1:0)}while(0==b)}b=Qa[a]=0<=b}return b}var Ra=l.document,Sa=Ra&&I?Ja()||("CSS1Compat"==Ra.compatMode?parseInt(Pa,10):5):void 0;var Ta=!I||I&&9<=Sa;!J&&!I||I&&I&&9<=Sa||J&&M("1.9.1");I&&M("9");function Ua(a,b){var c;c=a.className;c=t(c)&&c.match(/\S+/g)||[];for(var d=sa(arguments,1),e=c.length+d.length,f=c,g=0;g<d.length;g++)0<=oa(f,d[g])||f.push(d[g]);a.className=c.join(" ");return c.length==e};function Va(a,b){ua(b,function(b,d){"style"==d?a.style.cssText=b:"class"==d?a.className=b:"for"==d?a.htmlFor=b:d in Wa?a.setAttribute(Wa[d],b):0==d.lastIndexOf("aria-",0)||0==d.lastIndexOf("data-",0)?a.setAttribute(d,b):a[d]=b})}var Wa={cellpadding:"cellPadding",cellspacing:"cellSpacing",colspan:"colSpan",frameborder:"frameBorder",height:"height",maxlength:"maxLength",role:"role",rowspan:"rowSpan",type:"type",usemap:"useMap",valign:"vAlign",width:"width"};
function Xa(){var a=window.document,a="CSS1Compat"==a.compatMode?a.documentElement:a.body;return new E(a.clientWidth,a.clientHeight)}function Ya(){var a=document,b=K||"CSS1Compat"!=a.compatMode?a.body:a.documentElement,a=a.parentWindow||a.defaultView;return I&&M("10")&&a.pageYOffset!=b.scrollTop?new D(b.scrollLeft,b.scrollTop):new D(a.pageXOffset||b.scrollLeft,a.pageYOffset||b.scrollTop)}
function Za(a,b,c){var d=arguments,e=document,f=d[0],g=d[1];if(!Ta&&g&&(g.name||g.type)){f=["<",f];g.name&&f.push(' name="',ga(g.name),'"');if(g.type){f.push(' type="',ga(g.type),'"');var k={};za(k,g);delete k.type;g=k}f.push(">");f=f.join("")}f=e.createElement(f);g&&(t(g)?f.className=g:r(g)?Ua.apply(null,[f].concat(g)):Va(f,g));2<d.length&&$a(e,f,d);return f}
function $a(a,b,c){function d(c){c&&b.appendChild(t(c)?a.createTextNode(c):c)}for(var e=2;e<c.length;e++){var f=c[e];!s(f)||aa(f)&&0<f.nodeType?d(f):pa(ab(f)?C(f):f,d)}}function N(a){return document.createElement(a)}function bb(a){return a&&a.parentNode?a.parentNode.removeChild(a):null}function ab(a){if(a&&"number"==typeof a.length){if(aa(a))return"function"==typeof a.item||"string"==typeof a.item;if("function"==n(a))return"function"==typeof a.item}return!1};function cb(){}
function db(a,b,c){switch(typeof b){case "string":eb(b,c);break;case "number":c.push(isFinite(b)&&!isNaN(b)?b:"null");break;case "boolean":c.push(b);break;case "undefined":c.push("null");break;case "object":if(null==b){c.push("null");break}if(r(b)){var d=b.length;c.push("[");for(var e="",f=0;f<d;f++)c.push(e),db(a,b[f],c),e=",";c.push("]");break}c.push("{");d="";for(e in b)Object.prototype.hasOwnProperty.call(b,e)&&(f=b[e],"function"!=typeof f&&(c.push(d),eb(e,c),c.push(":"),db(a,f,c),d=","));c.push("}");
break;case "function":break;default:throw Error("Unknown type: "+typeof b);}}var fb={'"':'\\"',"\\":"\\\\","/":"\\/","\b":"\\b","\f":"\\f","\n":"\\n","\r":"\\r","\t":"\\t","\x0B":"\\u000b"},gb=/\uffff/.test("\uffff")?/[\\\"\x00-\x1f\x7f-\uffff]/g:/[\\\"\x00-\x1f\x7f-\xff]/g;function eb(a,b){b.push('"',a.replace(gb,function(a){if(a in fb)return fb[a];var b=a.charCodeAt(0),e="\\u";16>b?e+="000":256>b?e+="00":4096>b&&(e+="0");return fb[a]=e+b.toString(16)}),'"')};function O(a,b,c){t(b)?hb(a,c,b):ua(b,x(hb,a))}function hb(a,b,c){var d;t:if(d=ma(c),void 0===a.style[d]&&(c=(K?"Webkit":J?"Moz":I?"ms":Ga?"O":null)+na(c),void 0!==a.style[c])){d=c;break t}d&&(a.style[d]=b)}function ib(a,b,c){var d,e=J&&(Ca||Ia)&&M("1.9");b instanceof D?(d=b.x,b=b.y):(d=b,b=c);a.style.left=jb(d,e);a.style.top=jb(b,e)}function kb(a,b,c){if(b instanceof E)c=b.height,b=b.width;else if(void 0==c)throw Error("missing height argument");a.style.width=jb(b,!0);a.style.height=jb(c,!0)}
function jb(a,b){"number"==typeof a&&(a=(b?Math.round(a):a)+"px");return a}function lb(a,b){var c=a.style;"opacity"in c?c.opacity=b:"MozOpacity"in c?c.MozOpacity=b:"filter"in c&&(c.filter=""===b?"":"alpha(opacity="+100*b+")")};var mb="StopIteration"in l?l.StopIteration:Error("StopIteration");function nb(){}nb.prototype.a=function(){throw mb;};nb.prototype.ga=function(){return this};function ob(a,b){this.b={};this.a=[];this.h=this.d=0;var c=arguments.length;if(1<c){if(c%2)throw Error("Uneven number of arguments");for(var d=0;d<c;d+=2)this.set(arguments[d],arguments[d+1])}else if(a){a instanceof ob?(c=a.v(),d=a.k()):(c=xa(a),d=wa(a));for(var e=0;e<c.length;e++)this.set(c[e],d[e])}}h=ob.prototype;h.k=function(){pb(this);for(var a=[],b=0;b<this.a.length;b++)a.push(this.b[this.a[b]]);return a};h.v=function(){pb(this);return this.a.concat()};
h.remove=function(a){return P(this.b,a)?(delete this.b[a],this.d--,this.h++,this.a.length>2*this.d&&pb(this),!0):!1};function pb(a){if(a.d!=a.a.length){for(var b=0,c=0;b<a.a.length;){var d=a.a[b];P(a.b,d)&&(a.a[c++]=d);b++}a.a.length=c}if(a.d!=a.a.length){for(var e={},c=b=0;b<a.a.length;)d=a.a[b],P(e,d)||(a.a[c++]=d,e[d]=1),b++;a.a.length=c}}h.get=function(a,b){return P(this.b,a)?this.b[a]:b};h.set=function(a,b){P(this.b,a)||(this.d++,this.a.push(a),this.h++);this.b[a]=b};h.p=function(){return new ob(this)};
h.ga=function(a){pb(this);var b=0,c=this.a,d=this.b,e=this.h,f=this,g=new nb;g.a=function(){for(;;){if(e!=f.h)throw Error("The map has changed since the iterator was created");if(b>=c.length)throw mb;var g=c[b++];return a?g:d[g]}};return g};function P(a,b){return Object.prototype.hasOwnProperty.call(a,b)};function qb(a){if("function"==typeof a.k)return a.k();if(t(a))return a.split("");if(s(a)){for(var b=[],c=a.length,d=0;d<c;d++)b.push(a[d]);return b}return wa(a)}function rb(a,b,c){if("function"==typeof a.forEach)a.forEach(b,c);else if(s(a)||t(a))pa(a,b,c);else{var d;if("function"==typeof a.v)d=a.v();else if("function"!=typeof a.k)if(s(a)||t(a)){d=[];for(var e=a.length,f=0;f<e;f++)d.push(f)}else d=xa(a);else d=void 0;for(var e=qb(a),f=e.length,g=0;g<f;g++)b.call(c,e[g],d&&d[g],a)}};var sb=RegExp("^(?:([^:/?#.]+):)?(?://(?:([^/?#]*)@)?([^/#?]*?)(?::([0-9]+))?(?=[/#?]|$))?([^?#]+)?(?:\\?([^#]*))?(?:#(.*))?$");function tb(a){if(ub){ub=!1;var b=l.location;if(b){var c=b.href;if(c&&(c=(c=tb(c)[3]||null)&&decodeURIComponent(c))&&c!=b.hostname)throw ub=!0,Error();}}return a.match(sb)}var ub=K;function Q(a,b){var c;if(a instanceof Q)this.t=void 0!==b?b:a.t,vb(this,a.s),this.I=a.I,this.q=a.q,wb(this,a.F),this.D=a.D,xb(this,a.a.p()),this.G=a.G;else if(a&&(c=tb(String(a)))){this.t=!!b;vb(this,c[1]||"",!0);this.I=c[2]?decodeURIComponent(c[2]||""):"";var d=c[3]||"";this.q=d?decodeURIComponent(d):"";wb(this,c[4]);this.D=(d=c[5]||"")?decodeURIComponent(d):"";xb(this,c[6]||"",!0);this.G=(c=c[7]||"")?decodeURIComponent(c):""}else this.t=!!b,this.a=new R(null,0,this.t)}h=Q.prototype;h.s="";h.I="";
h.q="";h.F=null;h.D="";h.G="";h.t=!1;h.toString=function(){var a=[],b=this.s;b&&a.push(S(b,yb),":");if(b=this.q){a.push("//");var c=this.I;c&&a.push(S(c,yb),"@");a.push(encodeURIComponent(String(b)));b=this.F;null!=b&&a.push(":",String(b))}if(b=this.D)this.q&&"/"!=b.charAt(0)&&a.push("/"),a.push(S(b,"/"==b.charAt(0)?zb:Ab));(b=this.a.toString())&&a.push("?",b);(b=this.G)&&a.push("#",S(b,Bb));return a.join("")};h.p=function(){return new Q(this)};
function vb(a,b,c){a.s=c?b?decodeURIComponent(b):"":b;a.s&&(a.s=a.s.replace(/:$/,""))}function wb(a,b){if(b){b=Number(b);if(isNaN(b)||0>b)throw Error("Bad port number "+b);a.F=b}else a.F=null}function xb(a,b,c){b instanceof R?(a.a=b,Cb(a.a,a.t)):(c||(b=S(b,Db)),a.a=new R(b,0,a.t))}function S(a,b){return t(a)?encodeURI(a).replace(b,Eb):null}function Eb(a){a=a.charCodeAt(0);return"%"+(a>>4&15).toString(16)+(a&15).toString(16)}var yb=/[#\/\?@]/g,Ab=/[\#\?:]/g,zb=/[\#\?]/g,Db=/[\#\?@]/g,Bb=/#/g;
function R(a,b,c){this.a=a||null;this.b=!!c}function T(a){if(!a.g&&(a.g=new ob,a.j=0,a.a))for(var b=a.a.split("&"),c=0;c<b.length;c++){var d=b[c].indexOf("="),e=null,f=null;0<=d?(e=b[c].substring(0,d),f=b[c].substring(d+1)):e=b[c];e=decodeURIComponent(e.replace(/\+/g," "));e=U(a,e);a.add(e,f?decodeURIComponent(f.replace(/\+/g," ")):"")}}h=R.prototype;h.g=null;h.j=null;h.add=function(a,b){T(this);this.a=null;a=U(this,a);var c=this.g.get(a);c||this.g.set(a,c=[]);c.push(b);this.j++;return this};
h.remove=function(a){T(this);a=U(this,a);return P(this.g.b,a)?(this.a=null,this.j-=this.g.get(a).length,this.g.remove(a)):!1};function Fb(a,b){T(a);b=U(a,b);return P(a.g.b,b)}h.v=function(){T(this);for(var a=this.g.k(),b=this.g.v(),c=[],d=0;d<b.length;d++)for(var e=a[d],f=0;f<e.length;f++)c.push(b[d]);return c};h.k=function(a){T(this);var b=[];if(t(a))Fb(this,a)&&(b=ra(b,this.g.get(U(this,a))));else{a=this.g.k();for(var c=0;c<a.length;c++)b=ra(b,a[c])}return b};
h.set=function(a,b){T(this);this.a=null;a=U(this,a);Fb(this,a)&&(this.j-=this.g.get(a).length);this.g.set(a,[b]);this.j++;return this};h.get=function(a,b){var c=a?this.k(a):[];return 0<c.length?String(c[0]):b};function Gb(a,b,c){a.remove(b);0<c.length&&(a.a=null,a.g.set(U(a,b),C(c)),a.j+=c.length)}
h.toString=function(){if(this.a)return this.a;if(!this.g)return"";for(var a=[],b=this.g.v(),c=0;c<b.length;c++)for(var d=b[c],e=encodeURIComponent(String(d)),d=this.k(d),f=0;f<d.length;f++){var g=e;""!==d[f]&&(g+="="+encodeURIComponent(String(d[f])));a.push(g)}return this.a=a.join("&")};h.p=function(){var a=new R;a.a=this.a;this.g&&(a.g=this.g.p(),a.j=this.j);return a};function U(a,b){var c=String(b);a.b&&(c=c.toLowerCase());return c}
function Cb(a,b){b&&!a.b&&(T(a),a.a=null,rb(a.g,function(a,b){var e=b.toLowerCase();b!=e&&(this.remove(b),Gb(this,e,a))},a));a.b=b};function Hb(a){Hb[" "](a);return a}Hb[" "]=m;var Ib=!I||I&&9<=Sa,Jb=I&&!M("9");!K||M("528");J&&M("1.9b")||I&&M("8")||Ga&&M("9.5")||K&&M("528");J&&!M("8")||I&&M("9");function Kb(){};function V(a,b){this.type=a;this.a=this.C=b}V.prototype.b=!1;V.prototype.d=!1;V.prototype.h=!0;V.prototype.M=function(){this.d=!0;this.h=!1};function W(a,b){a&&this.init(a,b)}z(W,V);h=W.prototype;h.C=null;h.ba=null;h.$=0;h.aa=0;h.clientX=0;h.clientY=0;h.ca=0;h.da=0;h.V=0;h.Y=0;h.W=0;h.X=!1;h.U=!1;h.ea=!1;h.Z=!1;h.fa=!1;h.P=null;
h.init=function(a,b){var c=this.type=a.type;V.call(this,c);this.C=a.target||a.srcElement;this.a=b;var d=a.relatedTarget;if(d){if(J){var e;t:{try{Hb(d.nodeName);e=!0;break t}catch(f){}e=!1}e||(d=null)}}else"mouseover"==c?d=a.fromElement:"mouseout"==c&&(d=a.toElement);this.ba=d;this.$=K||void 0!==a.offsetX?a.offsetX:a.layerX;this.aa=K||void 0!==a.offsetY?a.offsetY:a.layerY;this.clientX=void 0!==a.clientX?a.clientX:a.pageX;this.clientY=void 0!==a.clientY?a.clientY:a.pageY;this.ca=a.screenX||0;this.da=
a.screenY||0;this.V=a.button;this.Y=a.keyCode||0;this.W=a.charCode||("keypress"==c?a.keyCode:0);this.X=a.ctrlKey;this.U=a.altKey;this.ea=a.shiftKey;this.Z=a.metaKey;this.fa=Ca?a.metaKey:a.ctrlKey;this.P=a;a.defaultPrevented&&this.M();delete this.b};h.M=function(){W.O.M.call(this);var a=this.P;if(a.preventDefault)a.preventDefault();else if(a.returnValue=!1,Jb)try{if(a.ctrlKey||112<=a.keyCode&&123>=a.keyCode)a.keyCode=-1}catch(b){}};var Lb="closure_listenable_"+(1E6*Math.random()|0);function Mb(a){try{return!(!a||!a[Lb])}catch(b){return!1}}var Nb=0;function Ob(a,b,c,d,e){this.u=a;this.proxy=null;this.src=b;this.type=c;this.capture=!!d;this.K=e;this.key=++Nb;this.removed=this.J=!1}function Pb(a){a.removed=!0;a.u=null;a.proxy=null;a.src=null;a.K=null};function Qb(a){this.src=a;this.i={};this.a=0}Qb.prototype.add=function(a,b,c,d,e){var f=this.i[a];f||(f=this.i[a]=[],this.a++);var g=Rb(f,b,d,e);-1<g?(a=f[g],c||(a.J=!1)):(a=new Ob(b,this.src,a,!!d,e),a.J=c,f.push(a));return a};Qb.prototype.remove=function(a,b,c,d){if(!(a in this.i))return!1;var e=this.i[a];b=Rb(e,b,c,d);return-1<b?(Pb(e[b]),B.splice.call(e,b,1),0==e.length&&(delete this.i[a],this.a--),!0):!1};
function Sb(a,b){var c=b.type;if(!(c in a.i))return!1;var d=a.i[c],e=oa(d,b),f;(f=0<=e)&&B.splice.call(d,e,1);f&&(Pb(b),0==a.i[c].length&&(delete a.i[c],a.a--));return f}function Rb(a,b,c,d){for(var e=0;e<a.length;++e){var f=a[e];if(!f.removed&&f.u==b&&f.capture==!!c&&f.K==d)return e}return-1};var Tb={},X={},Y={};function Ub(a,b,c,d,e){if(r(b))for(var f=0;f<b.length;f++)Ub(a,b[f],c,d,e);else c=Vb(c),Mb(a)?a.w.add(b,c,!1,d,e):Wb(a,b,c,!1,d,e)}function Wb(a,b,c,d,e,f){if(!b)throw Error("Invalid event type");var g=!!e,k=a[v]||(a[v]=++ba),p=X[k];p||(X[k]=p=new Qb(a));c=p.add(b,c,d,e,f);c.proxy||(d=Xb(),c.proxy=d,d.src=a,d.u=c,a.addEventListener?a.addEventListener(b,d,g):a.attachEvent(b in Y?Y[b]:Y[b]="on"+b,d),Tb[c.key]=c)}
function Xb(){var a=Yb,b=Ib?function(c){return a.call(b.src,b.u,c)}:function(c){c=a.call(b.src,b.u,c);if(!c)return c};return b}function Zb(a,b,c,d,e){if(r(b))for(var f=0;f<b.length;f++)Zb(a,b[f],c,d,e);else c=Vb(c),Mb(a)?a.w.add(b,c,!0,d,e):Wb(a,b,c,!0,d,e)}function $b(a,b,c,d,e){if(r(b))for(var f=0;f<b.length;f++)$b(a,b[f],c,d,e);else(c=Vb(c),Mb(a))?a.w.remove(b,c,d,e):a&&(d=!!d,a=ac(a))&&(b=a.i[b],a=-1,b&&(a=Rb(b,c,d,e)),(c=-1<a?b[a]:null)&&bc(c))}
function bc(a){if("number"==typeof a||!a||a.removed)return!1;var b=a.src;if(Mb(b))return Sb(b.w,a);var c=a.type,d=a.proxy;b.removeEventListener?b.removeEventListener(c,d,a.capture):b.detachEvent&&b.detachEvent(c in Y?Y[c]:Y[c]="on"+c,d);(c=ac(b))?(Sb(c,a),0==c.a&&(c.src=null,delete X[b[v]||(b[v]=++ba)])):Pb(a);delete Tb[a.key];return!0}function cc(a,b,c,d){var e=1;if(a=ac(a))if(b=a.i[b])for(b=C(b),a=0;a<b.length;a++){var f=b[a];f&&(f.capture==c&&!f.removed)&&(e&=!1!==dc(f,d))}return Boolean(e)}
function dc(a,b){var c=a.u,d=a.K||a.src;a.J&&bc(a);return c.call(d,b)}
function Yb(a,b){if(a.removed)return!0;if(!Ib){var c;if(!(c=b))t:{c=["window","event"];for(var d=l,e;e=c.shift();)if(null!=d[e])d=d[e];else{c=null;break t}c=d}e=c;c=new W(e,this);d=!0;if(!(0>e.keyCode||void 0!=e.returnValue)){t:{var f=!1;if(0==e.keyCode)try{e.keyCode=-1;break t}catch(g){f=!0}if(f||void 0==e.returnValue)e.returnValue=!0}e=[];for(f=c.a;f;f=f.parentNode)e.push(f);for(var f=a.type,k=e.length-1;!c.b&&0<=k;k--)c.a=e[k],d&=cc(e[k],f,!0,c);for(k=0;!c.b&&k<e.length;k++)c.a=e[k],d&=cc(e[k],
f,!1,c)}return d}return dc(a,new W(b,this))}function ac(a){return a[v]?X[a[v]||(a[v]=++ba)]||null:null}var ec="__closure_events_fn_"+(1E9*Math.random()>>>0);function Vb(a){return"function"==n(a)?a:a[ec]||(a[ec]=function(b){return a.handleEvent(b)})};Ub(window,"unload",function(){for(var a in X){var b=X[a];if(b){var c=0,d=void 0;for(d in b.i)for(var e=C(b.i[d]),f=0;f<e.length;++f)bc(e[f])&&++c}}});function fc(a,b){this.a=b||"en"}function gc(a){var b=N("img");b.src=fa("http://books.google.com/intl/%s/googlebooks/images/gbs_preview_button1.gif",a.a);b.border=0;O(b,"cursor","pointer");return b}function hc(a,b,c){this.a=c||"en";c=N("a");c.href=b;a.appendChild(c);a=gc(this);c.appendChild(a)}z(hc,fc);function ic(a,b,c){this.a=c||"en";c=gc(this);a.appendChild(c);O(a,"cursor","pointer");Ub(a,"click",b)}z(ic,fc);function jc(a,b){var c=document.getElementsByTagName("body")[0],d=N("div");lb(d,0.5);O(d,{backgroundColor:"#333",position:"absolute",zIndex:200});this.o=d;var e=c.scrollWidth,f=Math.max(c.scrollHeight,Xa().height);kb(d,e,f);ib(d,0,0);c.appendChild(d);this.d=N("div");O(this.d,{position:"absolute",zIndex:201});c.appendChild(this.d);this.b=N("div");kb(this.b,618,500);O(this.b,{backgroundColor:"#333",position:"absolute",zIndex:202});ib(this.b,3,3);lb(this.b,0.3);this.d.appendChild(this.b);this.a=N("div");
ib(this.a,0,0);O(this.a,{position:"absolute",padding:"8px",border:"1px solid #2c4462",backgroundColor:"#b4cffe",zIndex:203});c=N("div");O(c,{backgroundColor:"#d8e8fd",fontSize:"16px",fontFamily:"Arial, sans-serif",fontWeight:"bold",padding:"2px 2px 2px 5px"});this.a.appendChild(c);d=N("img");d.src="http://books.google.com/googlebooks/images/dialog_close_x.gif";d.width=15;d.height=15;O(d,{cursor:"pointer",position:"absolute",right:"11px",top:"11px"});Zb(d,"click",w(this.close,this));c.appendChild(d);
d=N("div");d.innerHTML="&nbsp;";c.appendChild(d);this.h=N("div");this.a.appendChild(this.h);kb(this.h,600,456);this.d.appendChild(this.a);b(this.h,a);d=Xa();c=Math.max(0,(d.height-500)/2);c=Math.floor(c+Ya().y);d=Math.max(0,(d.width-618)/2);d=Math.floor(d);ib(this.d,d,c)}jc.prototype.close=function(){pa([this.a,this.o,this.b],bb)};/*
 Portions of this code are from MochiKit, received by
 The Closure Authors under the MIT license. All other code is Copyright
 2005-2009 The Closure Authors. All Rights Reserved.
*/
function kc(a,b){this.d=[];this.S=b||null;this.b=this.a=!1;this.h=void 0;this.N=this.Q=this.A=!1;this.o=0;this.B=null;this.R=0}kc.prototype.H=function(a,b){this.A=!1;lc(this,a,b)};function lc(a,b,c){a.a=!0;a.h=c;a.b=!b;mc(a)}function nc(a){if(a.a){if(!a.N)throw new oc;a.N=!1}}function pc(a){return qa(a.d,function(a){return"function"==n(a[1])})}
function mc(a){a.o&&(a.a&&pc(a))&&(l.clearTimeout(a.o),delete a.o);a.B&&(a.B.R--,delete a.B);for(var b=a.h,c=!1,d=!1;a.d.length&&!a.A;){var e=a.d.shift(),f=e[0],g=e[1],e=e[2];if(f=a.b?g:f)try{var k=f.call(e||a.S,b);void 0!==k&&(a.b=a.b&&(k==b||k instanceof Error),a.h=b=k);b instanceof kc&&(d=!0,a.A=!0)}catch(p){b=p,a.b=!0,pc(a)||(c=!0)}}a.h=b;d&&(d=b,k=w(a.H,a,!0),f=w(a.H,a,!1),d.d.push([k,f,void 0]),d.a&&mc(d),b.Q=!0);c&&(a.o=l.setTimeout(ta(b),0))}function oc(){A.call(this)}z(oc,A);
oc.prototype.message="Deferred has already fired";oc.prototype.name="AlreadyCalledError";function qc(a,b){var c=b||{},d=c.document||document,e=N("SCRIPT"),f={a:e,L:void 0},g=new kc(0,f),k=null,p=null!=c.timeout?c.timeout:5E3;0<p&&(k=window.setTimeout(function(){rc(e,!0);var b=new sc(1,"Timeout reached for loading script "+a);nc(g);lc(g,!1,b)},p),f.L=k);e.onload=e.onreadystatechange=function(){e.readyState&&"loaded"!=e.readyState&&"complete"!=e.readyState||(rc(e,c.T||!1,k),nc(g),lc(g,!0,null))};e.onerror=function(){rc(e,!0,k);var b=new sc(0,"Error while loading script "+a);nc(g);lc(g,
!1,b)};Va(e,{type:"text/javascript",charset:"UTF-8",src:a});tc(d).appendChild(e);return g}function tc(a){var b=a.getElementsByTagName("HEAD");return b&&0!=b.length?b[0]:a.documentElement}function rc(a,b,c){null!=c&&l.clearTimeout(c);a.onload=m;a.onerror=m;a.onreadystatechange=m;b&&window.setTimeout(function(){bb(a)},0)}function sc(a,b){var c="Jsloader error (code #"+a+")";b&&(c+=": "+b);A.call(this,c)}z(sc,A);function uc(a){this.a=new Q(a);this.L=5E3}var vc=0;function wc(a,b,c){return function(){xc(a,!1);c&&c(b)}}function yc(a,b){return function(c){xc(a,!0);b.apply(void 0,arguments)}}function xc(a,b){l._callbacks_[a]&&(b?delete l._callbacks_[a]:l._callbacks_[a]=m)};function Z(){this.w=new Qb(this);this.o=this}z(Z,Kb);Z.prototype[Lb]=!0;Z.prototype.removeEventListener=function(a,b,c,d){$b(this,a,b,c,d)};function zc(a,b){var c=a.o,d=b,e=d.type||d;if(t(d))d=new V(d,c);else if(d instanceof V)d.C=d.C||c;else{var f=d,d=new V(e,c);za(d,f)}d.b||(c=d.a=c,Ac(c,e,!0,d),d.b||Ac(c,e,!1,d))}function Ac(a,b,c,d){if(b=a.w.i[b]){b=C(b);for(var e=!0,f=0;f<b.length;++f){var g=b[f];if(g&&!g.removed&&g.capture==c){var k=g.u,p=g.K||g.src;g.J&&Sb(a.w,g);e=!1!==k.call(p,d)&&e}}}};function Bc(){Z.call(this);this.h=null;this.d=!0}z(Bc,Z);Bc.prototype.b=function(){if(this.d)this.d=!1;else throw Error();};function $(a){Bc.call(this);this.H=new uc(a);this.a=!0}z($,Bc);
$.prototype.b=function(a,b){$.O.b.call(this,a,b);this.a=!1;var c=this.H,d=w(this.B,this,a),e=w(this.A,this,b),f={},g="_"+(vc++).toString(36)+ea().toString(36);l._callbacks_||(l._callbacks_={});var k=c.a.p();if(f)for(var p in f)if(!f.hasOwnProperty||f.hasOwnProperty(p)){var va=k,u=p,q=f[p];r(q)||(q=[String(q)]);Gb(va.a,u,q)}d&&(l._callbacks_[g]=yc(g,d),d="_callbacks_."+g,r(d)||(d=[String(d)]),Gb(k.a,"callback",d));c=qc(k.toString(),{timeout:c.L,T:!0});c.d.push([null,wc(g,f,e),void 0]);c.a&&mc(c)};
$.prototype.B=function(a,b){this.a||(this.h=b,zc(this,"success"),a&&a(this.h),this.a=!0)};$.prototype.A=function(a){this.a||(zc(this,"error"),a&&a(),this.a=!0)};function Cc(a,b,c,d){r(a)||(a=[a]);this.a=a;this.d=b;this.b=c;b=new Q(Dc);b.a.set("bibkeys",a.join(","));b.a.set("hl",GBS_LANG);b.a.set("source",d||"previewlib");(new $(b)).b(w(this.h,this))}var Dc=(GBS_HOST||"http://books.google.com/")+"books?jscmd=viewapi";Cc.prototype.h=function(a){for(var b=0;b<this.a.length;b++){var c=a[this.a[b]];if(c){var d=c.preview_url,e;if(e=d)e=c.preview,c=c.embeddable,void 0!==c||(c=!0),e=("full"==e||"partial"==e)&&c;if(e){this.d&&this.d(d);return}}}this.b&&this.b()};y("GBS_insertPreviewButtonLink",function(a,b){var c=x(Ec,(b||{}).alternativeUrl);Fc(a,c,"GBS_insertPreviewButtonLink")});y("GBS_insertPreviewButtonPopup",function(a){Fc(a,Gc,"GBS_insertPreviewButtonPopup")});y("GBS_insertEmbeddedViewer",function(a,b,c){Fc(a,x(Hc,b,c),"GBS_insertEmbeddedViewer")});function Fc(a,b,c){var d=Ic();new Cc(a,function(a){b(d,a)},null,c)}
function Ec(a,b,c){a||(a=new Q(c),Jc&&(c=new Q(GBS_HOST),vb(a,c.s),a.q=c.q,wb(a,c.F),a.D="/books/p/"+Jc),a.a.set("hl",Kc||"en"),a=a.toString());new hc(b,a,Kc)}function Gc(a,b){var c=x(Lc,b);new ic(a,c,Kc)}function Hc(a,b,c,d){var e=N("div");c.appendChild(e);kb(e,a,b);Mc(e,d)}
function Mc(a,b){var c=Za("iframe",{frameBorder:"0",width:"100%",height:"100%"});a.appendChild(c);var d=new Q(b);d.a.set("output","embed");if(Nc){var e=[];db(new cb,Nc,e);d.G=encodeURIComponent(String(e.join("")))}c.src=d.toString()}function Lc(a){new jc(a,Mc)}var Kc="en";y("GBS_setLanguage",function(a){Kc=a});y("GBS_setViewerOptions",function(a){Nc=a});var Jc=null;y("GBS_setCobrandName",function(a){Jc=a});var Nc={};
function Ic(){var a="__GBS_Button"+Oc++;document.write(fa('<span id="%s"></span>',a));var b=document;return t(a)?b.getElementById(a):a}var Oc=0;
})();