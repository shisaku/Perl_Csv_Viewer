use strict;
use warnings;
# use feature qw( say );
# use Data::Dumper;

my $conf_file = './data.pl';
my $c = do $conf_file or die "$!$@";

# say Dumper($c);
print $c->{site1}->{title};