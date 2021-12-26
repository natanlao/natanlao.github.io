Notes on the Signal backup database.

* Pre-2020. I used mossblaser/signal_for_android_decryption to get a dump of the
  SQLite database. Signal for Android supports both carrier SMS/MMS and Signal
  chats, and the dumped database has both.

* There are a few immediately interesting tables:
  - `sms`
  - `mms`
  - `recipient`

* Messages are split between `sms` and `mms` in ways that aren't 100% clear to
  me. SSM/MMS/Signal messages are apparently commingled in both tables. Received
  Signal group messages are in `sms` but messages I send to the same group might
  be in `mms`?

* Determining messages that I sent and messages that I received appears
  non-trivial. `sms.service_center` appears null for messages I send, and
  non-null for messages I receive.

* Maybe if, through Signal, your reply to a message, it ends up in `mms`.

* `mms.m_type = 132` for received messages, mms.m_type = 128` for sent messages?

* Not comprehensive, working on the clock.

* Threads and addresses -- threads are, roughly, conversations (DMs with
  individuals or group messages). I say "roughly" because I don't think they are
  comprehensive -- may be scattered between sms/mms tables.

* Addresses are roughly "people" -- see the recipients table.

