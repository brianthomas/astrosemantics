use AstroSemantics::TextProcessing;
use Test::More;
 
  require_ok ('AstroSemantics::TextProcessing');

  # basic id
  &check_id ("id", "id");
  &check_id ("#id", "id");
  &check_id ("-id", "id");
  &check_id ("--id", "id");
  &check_id ("--id--and--number2", "id--and--number2");
  &check_id ("-id--and--number2", "id--and--number2");
  &check_id ("#-id--and--number2", "id--and--number2");
  &check_id ("-#id--and--number2", "id--and--number2");

  # number conversion
  &check_id ("19str", "oneninestr");
  &check_id ("19#-str", "onenine#str");
  &check_id ("#19str", "oneninestr");
  &check_id ("-#19str", "oneninestr");
  &check_id ("--#19str", "oneninestr");

  # plural word conversion
  &check_id ("ids", "id");
  &check_id ("big_bag_of_gas", "big_bag_of_gas");

  # permutations on removing spaces for match
  done_testing();

1;


sub check_id ($$) {
  my ($val, $expected) = @_;

  my $result = &AstroSemantics::TextProcessing::getClassId($val); 
  ok(is($result, $expected));

}
