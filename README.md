# Keyfavors - A simple way to sign a bunch of keys

## Summary

`keyfavors` is a simple script that assists you in signing public keys
verified at a [Keysigning party](). 

## Installation

`keyfavors` uses `gpg`, and `gpg-agent` (if you have it), so be sure to 
have those.

To install, just copy `keyfavors.sh` somewhere and ensure it's got the
execute bit.

## Usage

In an ideal world, the host of the keysigning party will distribute
to you all the required information in a simple text file with the
following format:

    Name|Email Addr|Key id|Key path|Key Fingerprint
    
Where:

1. `Name` is the name of the key's owner. 
2. `Email Addr` is a valid identity for the key. 
3. `Key id` is the Key id of the public key
4. `Key path` is the path on the filesystem to the users public key
   *(Note: this is useful should the owner choose not to publish to a public keyserver)*
5. `Fingerprint` is the fingerprint of the key

Assuming you have the list of keys:

    $ /path/to/keyfavors.sh /path/to/keylist
    
keyfavors will then present each key to you and ask you to verify 
that the fingerprint you were presented with at the party is the same
as the ones it presents. If you'd like to sign the key, hit 'Y' when
the time comes, and it'll sign and send off.

If available, `gpg-agent` is started at the beginning of the script.
This will allow `gpg` to ask for your password only once (or at least
less frequently than on every signature). For more information on
`gpg-agent` see it's man page.

## Contributing and Feedback

It's possible that `keyfavors.sh` has bugs, and/or does something
it shouldn't be, and/or has lots of room for improvement. If you'd 
like to fix or contribute something, please fork and submit a pull
request, or open an issue.

If you have any other feedback, feel free to email me at the below
address.

## Authors

Andrew Gwozdziewycz <web@apgwoz.com>

## Copyright

Copyright 2014, Andrew Gwozdziewycz, <web@apgwoz.com>

Licensed under the GNU GPLv3. See keyfavors.sh for more details.
