import strutils
const sourcePath = currentSourcePath().split({'\\', '/'})[0..^2].join("/")
{.passC: "-I\"" & sourcePath & "kcp\"".}
const headerikcp = sourcePath & "kcp/ikcph"
{.compile: "kcp/ikcp.c".}
const
  IWORDS_BIG_ENDIAN* = 1
  IWORDS_BIG_ENDIAN* = 1
  IWORDS_BIG_ENDIAN* = 0
  IKCP_LOG_OUTPUT* = 1
  IKCP_LOG_INPUT* = 2
  IKCP_LOG_SEND* = 4
  IKCP_LOG_RECV* = 8
  IKCP_LOG_IN_DATA* = 16
  IKCP_LOG_IN_ACK* = 32
  IKCP_LOG_IN_PROBE* = 64
  IKCP_LOG_IN_WINS* = 128
  IKCP_LOG_OUT_DATA* = 256
  IKCP_LOG_OUT_ACK* = 512
  IKCP_LOG_OUT_PROBE* = 1024
  IKCP_LOG_OUT_WINS* = 2048

type
  ISTDUINT32* = cuint
  ISTDINT32* = cint
  IINT8* = char
  IUINT8* = cuchar
  IUINT16* = cushort
  IINT16* = cshort
  IINT32* = ISTDINT32
  IUINT32* = ISTDUINT32
  IINT64* = clonglong
  IUINT64* = culonglong
  IQUEUEHEAD* {.importc: "IQUEUEHEAD", header: headerikcp, bycopy.} = object
    next* {.importc: "next".}: ptr IQUEUEHEAD
    prev* {.importc: "prev".}: ptr IQUEUEHEAD

  iqueue_head* = IQUEUEHEAD
  IKCPSEG* {.importc: "IKCPSEG", header: headerikcp, bycopy.} = object
    node* {.importc: "node".}: IQUEUEHEAD
    conv* {.importc: "conv".}: IUINT32
    cmd* {.importc: "cmd".}: IUINT32
    frg* {.importc: "frg".}: IUINT32
    wnd* {.importc: "wnd".}: IUINT32
    ts* {.importc: "ts".}: IUINT32
    sn* {.importc: "sn".}: IUINT32
    una* {.importc: "una".}: IUINT32
    len* {.importc: "len".}: IUINT32
    resendts* {.importc: "resendts".}: IUINT32
    rto* {.importc: "rto".}: IUINT32
    fastack* {.importc: "fastack".}: IUINT32
    xmit* {.importc: "xmit".}: IUINT32
    data* {.importc: "data".}: array[1, char]

  IKCPCB* {.importc: "IKCPCB", header: headerikcp, bycopy.} = object
    conv* {.importc: "conv".}: IUINT32
    mtu* {.importc: "mtu".}: IUINT32
    mss* {.importc: "mss".}: IUINT32
    state* {.importc: "state".}: IUINT32
    snd_una* {.importc: "snd_una".}: IUINT32
    snd_nxt* {.importc: "snd_nxt".}: IUINT32
    rcv_nxt* {.importc: "rcv_nxt".}: IUINT32
    ts_recent* {.importc: "ts_recent".}: IUINT32
    ts_lastack* {.importc: "ts_lastack".}: IUINT32
    ssthresh* {.importc: "ssthresh".}: IUINT32
    rx_rttval* {.importc: "rx_rttval".}: IINT32
    rx_srtt* {.importc: "rx_srtt".}: IINT32
    rx_rto* {.importc: "rx_rto".}: IINT32
    rx_minrto* {.importc: "rx_minrto".}: IINT32
    snd_wnd* {.importc: "snd_wnd".}: IUINT32
    rcv_wnd* {.importc: "rcv_wnd".}: IUINT32
    rmt_wnd* {.importc: "rmt_wnd".}: IUINT32
    cwnd* {.importc: "cwnd".}: IUINT32
    probe* {.importc: "probe".}: IUINT32
    current* {.importc: "current".}: IUINT32
    interval* {.importc: "interval".}: IUINT32
    ts_flush* {.importc: "ts_flush".}: IUINT32
    xmit* {.importc: "xmit".}: IUINT32
    nrcv_buf* {.importc: "nrcv_buf".}: IUINT32
    nsnd_buf* {.importc: "nsnd_buf".}: IUINT32
    nrcv_que* {.importc: "nrcv_que".}: IUINT32
    nsnd_que* {.importc: "nsnd_que".}: IUINT32src
    nodelay* {.importc: "nodelay".}: IUINT32
    updated* {.importc: "updated".}: IUINT32
    ts_probe* {.importc: "ts_probe".}: IUINT32src
    probe_wait* {.importc: "probe_wait".}: IUIsrc2
    dead_link* {.importc: "dead_link".}: IUINTsrc
    incr* {.importc: "incr".}: IUINT32
    snd_queue* {.importc: "snd_queue".}: IQUEUEHEAD
    rcv_queue* {.importc: "rcv_queue".}: IQUEUEHEAD
    snd_buf* {.importc: "snd_buf".}: IQUEUEHEAD
    rcv_buf* {.importc: "rcv_buf".}: IQUEUEHEAD
    acklist* {.importc: "acklist".}: ptr IUINT32
    ackcount* {.importc: "ackcount".}: IUINT32
    ackblock* {.importc: "ackblock".}: IUINT32
    user* {.importc: "user".}: pointer
    buffer* {.importc: "buffer".}: cstring
    fastresend* {.importc: "fastresend".}: cint
    nocwnd* {.importc: "nocwnd".}: cint
    stream* {.importc: "stream".}: cint
    logmask* {.importc: "logmask".}: cint
    output* {.importc: "output".}: proc (buf: cstring; len: cint; kcp: ptr IKCPCB;
                                     user: pointer): cint {.stdcall.}
    writelog* {.importc: "writelog".}: proc (log: cstring; kcp: ptr IKCPCB; user: pointer) {.
        stdcall.}

  ikcpcb* = IKCPCB

proc ikcp_create*(conv: IUINT32; user: pointer): ptr ikcpcb {.stdcall,
    importc: "ikcp_create", header: headerikcp.}
proc ikcp_release*(kcp: ptr ikcpcb) {.stdcall, importc: "ikcp_release",
                                  header: headerikcp.}
proc ikcp_setoutput*(kcp: ptr ikcpcb; output: proc (buf: cstring; len: cint;
    kcp: ptr ikcpcb; user: pointer): cint {.stdcall.}) {.stdcall,
    importc: "ikcp_setoutput", header: headerikcp.}
proc ikcp_recv*(kcp: ptr ikcpcb; buffer: cstring; len: cint): cint {.stdcall,
    importc: "ikcp_recv", header: headerikcp.}
proc ikcp_send*(kcp: ptr ikcpcb; buffer: cstring; len: cint): cint {.stdcall,
    importc: "ikcp_send", header: headerikcp.}
proc ikcp_update*(kcp: ptr ikcpcb; current: IUINT32) {.stdcall, importc: "ikcp_update",
    header: headerikcp.}
proc ikcp_check*(kcp: ptr ikcpcb; current: IUINT32): IUINT32 {.stdcall,
    importc: "ikcp_check", header: headerikcp.}
proc ikcp_input*(kcp: ptr ikcpcb; data: cstring; size: clong): cint {.stdcall,
    importc: "ikcp_input", header: headerikcp.}
proc ikcp_flush*(kcp: ptr ikcpcb) {.stdcall, importc: "ikcp_flush", header: headerikcp.}
proc ikcp_peeksize*(kcp: ptr ikcpcb): cint {.stdcall, importc: "ikcp_peeksize",
                                        header: headerikcp.}
proc ikcp_setmtu*(kcp: ptr ikcpcb; mtu: cint): cint {.stdcall, importc: "ikcp_setmtu",
    header: headerikcp.}
proc ikcp_wndsize*(kcp: ptr ikcpcb; sndwnd: cint; rcvwnd: cint): cint {.stdcall,
    importc: "ikcp_wndsize", header: headerikcp.}
proc ikcp_waitsnd*(kcp: ptr ikcpcb): cint {.stdcall, importc: "ikcp_waitsnd",
                                       header: headerikcp.}
proc ikcp_nodelay*(kcp: ptr ikcpcb; nodelay: cint; interval: cint; resend: cint; nc: cint): cint {.
    stdcall, importc: "ikcp_nodelay", header: headerikcp.}
proc ikcp_log*(kcp: ptr ikcpcb; mask: cint; fmt: cstring) {.varargs, stdcall,
    importc: "ikcp_log", header: headerikcp.}
proc ikcp_allocator*(new_malloc: proc (a1: csize): pointer {.stdcall.};
                    new_free: proc (a1: pointer) {.stdcall.}) {.stdcall,
    importc: "ikcp_allocator", header: headerikcp.}
proc ikcp_getconv*(`ptr`: pointer): IUINT32 {.stdcall, importc: "ikcp_getconv",
    header: headerikcp.}