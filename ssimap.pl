#!/usr/bin/env perl
#use strict;
use warnings;
use Mail::IMAPClient;
use IO::Socket::SSL;
use Mail::IMAPClient::BodyStructure;

# Connect to the IMAP server via SSL
my $socket = IO::Socket::SSL->new(
   PeerAddr => 'imap.gmail.com',
   PeerPort => 993,
  )
  or die "socket(): $@";

# Build up a client attached to the SSL socket.
# Login is automatic as usual when we provide User and Password
my $client = Mail::IMAPClient->new(
   Socket   => $socket,
   User     => 'vikas.parashar@fosteringlinux.com',
   Password => 'redhat@123',
  )
  or die "new(): $@";

# Do something just to see that it's all ok
print "I'm authenticated\n" if $client->IsAuthenticated();
my @folders = $client->folders();

# @msgs;

#going to select a foler
foreach (@folders){
#	print $_;
	if ( $_ =~ m/sent/i ){
		$client->select($_) or die "Could not select: $@\n";
		 @msgs = $client->sentsince(time) or warn "Could not find any messages sent since $@\n";
	    	$client->select("$_") or die "Could not select INBOX: $@\n";

	}
}

foreach(@msgs)
{
print $_; print "\n";
}

foreach  (@msgs) {
	my $messageId = $client->get_header($_, "To") ;
	print $messageId;
	print "\n";
#      my $parts = map( "\n\t" . $_, $bso->parts );
#      print "Msg $id (Content-type: ) contains these parts:$parts\n";
  }

# Say bye
$client->logout();
