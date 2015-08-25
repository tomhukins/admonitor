=pod
Admonitor - Server monitoring software
Copyright (C) 2015 Ctrl O Ltd

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=cut

package Admonitor::Plugin::Agent::Memory;

use strict;
use warnings;

use Moo;

extends 'Admonitor::Plugin::Agent';

has stattypes => (
    is      => 'ro',
    default => sub {
        [
            {
                name => 'memusedper',
                type => 'decimal',
                read => 'avg',
            },
        ],
    },
);

sub read
{   my $self = shift;
    my $lxs = Sys::Statistics::Linux->new(memstats => 1);
    my $stat = $lxs->get;
    {
        memusedper => $stat->memstats->{memusedper},
    };
}

sub write
{   my ($self, $data) = @_;
    $self->write_single('memusedper', undef, $data->{memusedper});
}

1;

