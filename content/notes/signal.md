+++
title = "Signal backup database schema"
date = "2021-12-23"
+++

I have a Signal for Android backup (from around 2020) that I wanted to extract
messages from. I used [signal_for_android_decryption] to decrypt that backup and
extra an SQLite database from it. These are my notes from trying to
reverse-engineer the database schema, which is not well-documented, to extract
the messages I wanted.

In retrospect, I didn't have to "reverse engineer" the schema since the source
code for Signal for Android is [publicly available][signalapp/Signal-Android]
but (1) I didn't think of that at the time and (2) I'm not confident in my Java
/ Kotlin skills anyway. See also [signalapp/Signal-Android#7586].

  [signal_for_android_decryption]: https://github.com/mossblaser/signal_for_android_decryption

  [signalapp/Signal-Android]: https://github.com/signalapp/Signal-Android

  [signalapp/Signal-Android#7586]: https://github.com/signalapp/Signal-Android/issues/7586

If I ever revisit this (which I probably will), I'll probably take a look at the
source code and update these notes. (I wrote this in a hurry, so don't take this
as gospel.)

* Signal for Android commingles Signal group messages and direct messages with
  carrier SMS and MMS. The exported database has all of these. My goal was to
  retrieve Signal group messages and direct messages to certain recipients.

* There are a few immediately interesting tables:
  - `sms`
  - `mms`
  - `recipient`

* Messages are split between `sms` and `mms` in ways that aren't 100% clear to
  me. SSM/MMS/Signal messages are apparently present in both tables. Received
  Signal group messages are in `sms` but messages I send to the same group might
  be in `mms`?

* Determining messages that I sent and messages that I received appears
  non-trivial. `sms.service_center` appears null for messages I send, and
  non-null for messages I receive.

* Maybe if, through Signal, your reply to a message, it ends up in `mms`.

* `mms.m_type = 132` for received messages, `mms.m_type = 128` for sent messages?

* Threads and addresses -- threads are, roughly, conversations (DMs with
  individuals or group messages). I say "roughly" because I don't think they are
  comprehensive -- may be scattered between sms/mms tables.

* Addresses are roughly "people" -- see the recipients table.

