use strict; use warnings;
use Test::More;

use immutable::0 ':all';
use immutable::lens;

sub street {
  my ($name, $number) = @_;
  bless {name => $name, number => $number}, 'Street'
}
my $street = street 'St James', 10;

sub address {
  my ($country, $street) = @_;
  bless {country => $country, street => $street}, 'Address';
}
my $address = address 'GB', $street;

my $address_street_lens = immutable::lens->make(
  sub { $_[0]->{'street'} },
  sub {
    my ($address, $new_street) = @_;
    address $address->{'country'}, $new_street;
  });
my $street_number_lens = immutable::lens->make(
  sub { $_[0]->{'number'} },
  sub {
    my ($street, $new_street_number) = @_;
    street $street->{'name'}, $new_street_number;
  });

is $street_number_lens->view($street), 10,
  'can view a lens';

{
  my $new_street = $street_number_lens->set($street, 11);
  is $new_street->{'name'}, $street->{'name'},
    'other properties aren\'t updated';
  is $new_street->{'number'}, 11,
    'lens property is updated';
  is $street->{'number'}, 10,
    'original object is left unchanged';
}

{
  my $new_street = $street_number_lens->modify($street, sub {$_[0] * 2});
  is $new_street->{'number'}, 20,
    'modify passes the current value';
  is $street_number_lens->view($new_street), 20,
    'modify passes the current value';
}

{
  my $address_street = $address_street_lens->view($address);
  is $address_street, $street,
    'can view an object through a lens';
}

{
  my $new_street = $street_number_lens->set($street, 11);
  my $new_address = $address_street_lens->set($address, $new_street);
  is $new_address->{'street'}, $new_street,
    'lens property updated an object';
  is $address_street_lens->view($new_address), $new_street,
    'lens property updated an object';
  is $address->{'street'}, $street,
    'original object is left unchanged';
  is $address_street_lens->view($address), $street,
    'original object viewed is left unchanged';
}

{
  my $composed = $address_street_lens->compose($street_number_lens);
  is $composed->view($address), 10,
    'can view a composed lens';
  my $new_address = $composed->set($address, 11);
  is $composed->view($address), 10,
    'composed lens left original unchanged';
  is $composed->view($new_address), 11,
    'lens property updated a nested object';
  is $new_address->{'street'}{'number'}, 11,
    'lens property updated a nested object';
  my $new_street = $address_street_lens->view($new_address);
  is $new_street->{'number'}, 11,
    'viewed element was updated after composed set';
  is $street_number_lens->view($new_street), 11,
    'reapplying a second view gets the proper deep updated object';
}

{
  my $composed = $address_street_lens->compose($street_number_lens);
  my $new_address = $composed->modify($address, sub { $_[0] * 2 });
  is $composed->view($address), 10,
    'composed lens left original unchanged';
  is $composed->view($new_address), 20,
    'lens property updated a nested object';
}

done_testing;
