#!/usr/bin/perl

use XML::Simple;
use MIME::Base64;
use Getopt::Long qw(GetOptions);

my $source_address;
GetOptions('f=s' => \$source_address) or die "Usage: $0 -f <Filepath>";

$xml = new XML::Simple;

$data = $xml->XMLin($source_address);

$Filelist = $data->{Filelist}{File};
$Description = $data->{Description};
$BuildDate = $data->{BuildDate};
$Vendor = $data->{Vendor};
$URL = $data->{URL};
$License = $data->{License};
$Framework = $data->{Framework};
$Name = $data->{Name};
$Buildhost = $data->{BuildHost};
$Version = $data->{Version};

mkdir("$Name", 0777);

foreach my $File (@{ $Filelist }) {
    my($Location) = $File->{Location} =~ /.*\/(.*)/;
    unless(open FILE, ">$Name/$Location") {
        die "\nUnable to create $Location\n";
    }
    print FILE decode_base64($File->{content});
    close FILE;
}

unless(open FILE, ">$Name/$Name.sopm") {
        die "\nUnable to create $Name.sopm\n";
    }
    print FILE "
<?xml version=\"1.0\" encoding=\"utf-8\" ?>
<otrs_package version=\"1.0\">
    <Name>$Name</Name>
    <Version>$Version</Version>
    <Framework>$Framework</Framework>
    <Vendor>$Vendor</Vendor>
    <URL>$URL</URL>
    <License>$License</License>
</otrs_package>
    ";
    close FILE;