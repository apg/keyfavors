#!/usr/bin/env bash
# keyfavors.sh, version 0.1 - A simple way to sign a bunch of keys
#
# Copyright 2014, Andrew Gwozdziewycz <web@apgwoz.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

[ $# -eq "1" ] || (echo "usage: keyfavors.sh keylist" ; exit 1)

: ${GPG:=`which gpg`}

# Is there an agent?
if [ -z "$GPG_AGENT_INFO" ] && which gpg-agent > /dev/null ; then
    echo "+ Starting available GPG agent"
    eval $(gpg-agent --daemon);
    AGENT="yes"
fi

OLDIFS=$IFS
IFS="|"

while read -u 4 -r line; do
   # split line into Name, Email, Key-ID, Key-File, Fingerprint,
   set -- "$line"
   declare -a pieces=($*)

   echo "${pieces[0]} <${pieces[1]}>"
   echo "---------------------------"

   # does this user have a pubkey in this directory?
   if [ -z "${pieces[3]}" ]; then
       echo "+ Importing ${pieces[2]} from keyserver"
       $GPG --recv-key ${pieces[2]}
       PUBLISH="yes"
   else
       echo "+ Importing public key from file ${pieces[3]}"
       $GPG --import --armor ${pieces[3]}
       PUBLISH="no"
   fi

   echo
   echo "Please ensure all 3 copies match: "
   echo "    1) Check your hard copy record"
   echo "    2) Presented with this script:"
   echo "                        ${pieces[4]}"
   echo "    3) Computed from imported key by GPG:"
   $GPG --fingerprint ${pieces[2]} | grep 'Key fingerprint'

   echo

   read -u 0 -p "Sign this key? [y/N] " -a y

   case "$y" in
       y|Y)
           $GPG --use-agent --sign-key ${pieces[2]}

           if [ "$PUBLISH" = "yes" ]; then
               echo "+ Publishing signed key for ${pieces[1]}"
               $GPG --send-key ${pieces[2]}
               echo "+ Successfully signed key for ${pieces[0]}"
               echo
           else
               echo 
               echo "NOTE: " 
               echo "${pieces[0]} doesn't want their key published."
               echo
               echo "Please contact them at ${pieces[1]} and ask them how they"
               echo "want the signed key returned to them."
               echo
           fi
           ;;
       *)
           echo "+ Not signing this key. If you decide to later:"
           echo ""
           echo "    gpg --sign-key ${pieces[2]}"

           if [ "$PUBLISH" = "yes" ]; then
               echo "    gpg --send-key ${pieces[2]}"
               echo
           else
               echo
               echo "NOTE: " 
               echo "${pieces[0]} doesn't want their key published."
               echo
               echo "Please contact them at ${pieces[1]} and ask them how they"
               echo "want the signed key returned to them."
               echo
           fi
   esac

   echo
done \
    4<$1

IFS=$OLDIFS

if [ -n "$AGENT" ]; then
    echo "I started gpg-agent for you. Go ahead and kill it if you like."
    echo "It's probably PID=$(ps --no-headers -o pid -C gpg-agent)"
fi
