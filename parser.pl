#!/usr/bin/perl
# Perl-Skript zum Transfer ODL-Daten -> DAPNET
#
# developed since 05/31/2017 by Michael DG5MM
# rev: 0.1
#
#
# todo:
#
# required: 	libwww-perl; 					(via Ubuntu-Repositories)
#		JSON::Parse; 				(via CPAN)

use LWP;
use LWP::UserAgent;
use JSON::Parse 'parse_json';
use REST::Client;
use MIME::Base64;
use LWP::UserAgent;
use utf8;

$dataroot = 'https://odlinfo.bfs.de/daten/';		# Stammverzeichnis der ODL-Daten
$stammfile = 'json/stamm.json';				# JSON-File beim BfS
$user = 'xxxxx';					# Benutzername bei den ODL-Daten
$passwd = 'xxxx';					# Passwort bei den ODL-Daten
$dapnethost = 'hampager.de';				# DAPNET-Server-Host
$dapnetport = '8080';					# DAPNET-Server-Port
$dapnetuser = 'xxxx';					# Benutzername am DAPNET-Server
$dapnetpw = 'xxxxxx';					# Passwort am DAPNET-Server


$ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });				# LWP-Client für HTTPS-Abruf der Daten
$req = HTTP::Request->new(GET => "$dataroot$stammfile");					# dieses File wird abgerufen
$req->authorization_basic($user, $passwd);							# mit diesen Credentials
$c = REST::Client->new();									# und wir klöppeln uns einen neuen REST-Client
$c->setHost("$dapnethost:$dapnetport");								# zu diesem Server/Port
$c->addHeader('Authorization'=>'Basic ' . encode_base64($dapnetuser . ':' . $dapnetpw));	# mit diesen Credentials
$c->addHeader('charset', 'UTF-8');								# UTF-8 encoded
$c->addHeader('Content-Type', 'application/json');
$c->addHeader('Accept', 'application/json');
my $daten = parse_json($ua->request($req)->content);						# hole die Daten beim BfS und jage sie gleich durch den JSON-Parser

#################################
#				#
# Rubrik Wetter-NRW		#
#				#
#################################

#ODL Aachen-Laurensberg
my $wert = $daten->{'053130003'}->{'mw'};							# ID der Messstelle, und hierüber den mittleren 1-Stundenwert
$wert =~ tr/./,/;										# deutsche Notation, Komma statt Punkt als Dezimaltrenner
my $nachricht = "52072 Aachen        Ortsdosisleistung   " . $wert . " uSv/h";			# 1. bis beginnend 3. Zeile der Nachricht
while (length($nachricht) < 60) {								# fülle dritte Zeile auf
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";								# vierte Zeile (Quellenangabe)
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "wetter-nw", "text": "'.$nachricht.'", "number": 3 }');	# ab dafür ins DAPNET via REST-API

#ODL Brüggen
$wert = $daten->{'051660041'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "41379 Brüggen       Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
$c->POST('/news', '{"rubricName": "wetter-nw", "text": "'.$nachricht.'", "number": 4 }', {"Content-type"=>'application/json'});

#ODL Hürtgenwald-Kleinau
$wert = $daten->{'053580161'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "52393 Hürtgenwald   Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "wetter-nw", "text": "'.$nachricht.'", "number": 5 }', {"Content-type"=>'application/json'});

#ODL Pulheim
my $wert = $daten->{'053620361'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "50259 Pulheim        Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "wetter-nw", "text": "'.$nachricht.'", "number": 6 }', {"Content-type"=>'application/json'});


#################################
#				#
# Rubrik ODL			#
#				#
#################################

#ODL Krummhoern-Campen
my $wert = $daten->{'034520142'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "26736 Krummhörn     Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 1 }', {"Content-type"=>'application/json'});

#ODL Hamburg-Fuhlsbuettel
my $wert = $daten->{'020040001'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "22335 Hamburg       Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 2 }', {"Content-type"=>'application/json'});

#ODL Usedom
my $wert = $daten->{'130590972'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "17406 Usedom        Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 3 }', {"Content-type"=>'application/json'});

#ODL Pulheim
my $wert = $daten->{'053620361'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "50259 Pulheim        Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 4 }', {"Content-type"=>'application/json'});

#ODL Braunschweig (PTB)
my $wert = $daten->{'031010004'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "38116 Braunschweig  Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 5 }', {"Content-type"=>'application/json'});

#ODL Berlin-Tempelhof
my $wert = $daten->{'110000010'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "12101 Berlin-TempelhOrtsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 6 }', {"Content-type"=>'application/json'});

#ODL Saarbrücken-Gersweiler
my $wert = $daten->{'100411002'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "66128 Saarbrücken   Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 7 }', {"Content-type"=>'application/json'});

#ODL Erfurt
my $wert = $daten->{'160510002'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "99099 Erfurt        Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 8 }', {"Content-type"=>'application/json'});

#ODL Stuttgart
my $wert = $daten->{'081110002'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "70173 Stuttgart     Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 9 }', {"Content-type"=>'application/json'});

#ODL Zugspitze
my $wert = $daten->{'091801173'}->{'mw'};
$wert =~ tr/./,/;
my $nachricht = "Zugspitze           Ortsdosisleistung   " . $wert . " uSv/h";
while (length($nachricht) < 60) {
      $nachricht .= ' ';
}
$nachricht .= "(von odlinfo.bfs.de)";
utf8::encode($nachricht);
$c->POST('/news', '{"rubricName": "odl", "text": "'.$nachricht.'", "number": 10 }', {"Content-type"=>'application/json'});
