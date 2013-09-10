package SHARYANTO::Number::Util;

use 5.010001;
use locale;
use strict;
use utf8;
use warnings;

# VERSION

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(format_metric);

sub format_metric {
    my ($num, $opts) = @_;
    $opts //= {};
    $opts->{base} //= 2;

    my $im    = $opts->{i_mark} // 1;
    my $base0 = $opts->{base};
    my $base  = $base0 == 2 ? 1024 : 1000;

    my $rank;
    my $prefix;
    if ($num == 0) {
        $rank = 0;
        $prefix = "";
    } else {
        $rank = int(log(abs($num))/log($base));
        if    ($rank ==  0 && abs($num) >= 1) { $prefix = ""  }
        elsif ($rank ==  1) { $prefix = $im && $base0==10 ? "ki" : "k" } # kilo
        elsif ($rank ==  2) { $prefix = $im && $base0==10 ? "Mi" : "M" } # mega
        elsif ($rank ==  3) { $prefix = $im && $base0==10 ? "Gi" : "G" } # giga
        elsif ($rank ==  4) { $prefix = $im && $base0==10 ? "Ti" : "T" } # tera
        elsif ($rank ==  5) { $prefix = $im && $base0==10 ? "Pi" : "P" } # peta
        elsif ($rank >=  8) { $prefix = $im && $base0==10 ? "Yi" : "Y" } # yotta
        elsif ($rank ==  7) { $prefix = $im && $base0==10 ? "Zi" : "Z" } # zetta
        elsif ($rank ==  6) { $prefix = $im && $base0==10 ? "Ei" : "E" } # exa
        elsif ($rank ==  0) { $prefix = "m" } # milli
        elsif ($rank == -1) { $prefix = "μ" } # micro
        elsif ($rank == -2) { $prefix = "n" } # nano
        elsif ($rank == -3) { $prefix = "p" } # pico
        elsif ($rank == -4) { $prefix = "f" } # femto
        elsif ($rank == -5) { $prefix = "a" } # atto
        elsif ($rank == -6) { $prefix = "z" } # zepto
        elsif ($rank <= -7) { $prefix = "y" } # yocto
    }

    my $prec = $opts->{precision} // 1;
    $num = $num / $base**($rank <= 0 && abs($num) < 1 ? $rank-1 : $rank);
    if ($opts->{return_array}) {
        return [$num, $prefix];
    } else {
        my $snum = sprintf("%.${prec}f", $num);
        return $snum . $prefix;
    }
}

1;
# ABSTRACT: Number utilities

=head1 SYNOPSIS

=head1 FUNCTIONS

=head2 format_metric($num, \%opts) => STR

Format C<$num> using metric prefix, e.g.:

 format_metric(14     , {base=>10});               # => "14"
 format_metric(12000  , {base=> 2, precision=>1}); # => "11.7K"
 format_metric(12000  , {base=>10, precision=>1}); # => "11.7Ki"
 format_metric(-0.0017, {base=>10});               # => "1.7m"

Known options:

=over

=item * base => INT (either 2 or 10, default: 2)

=item * precision => INT

=item * i_mark => BOOL (default: 1)

Give "i" suffix to prefixes when in base 10 for K, M, G, T, and so on.

=back


=head1 SEE ALSO

Number formatting routines: L<Number::Format>, L<Format::Human::Bytes>,
L<Number::Bytes::Human>.

https://en.wikipedia.org/wiki/Metric_prefix

=cut
