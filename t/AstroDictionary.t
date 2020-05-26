use AstroSemantics::AstroDictionary;
use Test::More;
 
  require_ok ('AstroSemantics::AstroDictionary');

  # basic match
  &check_synonyms ("stellar", "star");

  # basic non-match
  &check_synonyms ("dude", undef);

  # permutations on removing spaces for match
  &check_synonyms ("globular_star_cluster", "globular_cluster");
  &check_synonyms ("-globular_star_cluster", "globular_cluster");
  &check_synonyms ("globular-star_cluster", "globular_cluster");
  &check_synonyms ("globular-star-cluster", "globular_cluster");
  &check_synonyms ("globular star cluster", "globular_cluster");
  &check_synonyms ("globular-star cluster", "globular_cluster");
  &check_synonyms ("globular--star--cluster", undef);
  &check_synonyms ("globular--star_cluster", undef);
  &check_synonyms ("globular-star", undef);
  &check_synonyms ("globular star", undef);

  &check_hypernyms ("a1", "heao-1", 0);

  done_testing();

1;


sub check_hypernyms ($) {
  my ($term, $expected, $pos) = @_;

  my @hypernyms = &AstroSemantics::AstroDictionary::getHypernyms($term); 
  ok(is($hypernyms[$pos], $expected));

}

sub check_synonyms ($) {
  my ($term, $expected) = @_;

  my @synonyms = &AstroSemantics::AstroDictionary::getSynonyms($term); 
  ok(is($synonyms[0], $expected));

}
