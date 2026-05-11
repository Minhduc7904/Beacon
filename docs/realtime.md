# Realtime (SignalR)

## Tong quan

Realtime layer su dung SignalR de ket noi tu app den backend. Hien tai chi khoi tao ket noi va xac thuc token, chua xu ly event.

## Cau hinh

- Env:
  - SIGNALR_HUB_URL (uu tien)
  - Neu khong co, tu dong fallback tu BASE_URL (bo /api/v1 va them /hubs/beacon)

## Cau truc file

```
lib/core/realtime/
  signalr_service.dart
  realtime_logger.dart
```

## Lifecycle hien tai

1) Login thanh cong
- AuthNotifier goi SignalRService.connect()

2) Mo lai app neu da co token
- SplashPage goi SignalRService.connect()

3) Logout
- AuthNotifier goi SignalRService.disconnect()

## Logging (chi debug)

Realtime log tap trung tai RealtimeLogger, format tuong tu HTTP logging:

```
------------------------------------------
REALTIME CONNECT
  URL     : http://10.0.2.2:5000/hubs/beacon
------------------------------------------

------------------------------------------
REALTIME CONNECTED
  URL     : http://10.0.2.2:5000/hubs/beacon
  ID      : <connectionId>
------------------------------------------

------------------------------------------
REALTIME RECONNECTING
  URL     : http://10.0.2.2:5000/hubs/beacon
  ERROR   : <error>
------------------------------------------
```

## Luu y

- Token truyen qua accessTokenFactory, khong log token ra console.
- Chua co event handler; se bo sung o SignalRService khi can.
