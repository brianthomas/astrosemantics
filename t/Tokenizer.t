use AstroSemantics::Tokenizer;
use List::MoreUtils qw/uniq/;
use Test::More;
  
  require_ok ('AstroSemantics::Tokenizer');
  use AstroSemantics::Tokenizer;

  open(TSUB, "t/test_subject_list");

  &AstroSemantics::Tokenizer::setDebug(0);
  &AstroSemantics::Tokenizer::setChatty(0);
#  &AstroSemantics::Tokenizer::setReportStats(0);
  &AstroSemantics::Tokenizer::setSplitDashedTerms(0);

  for my $test (<TSUB>) {
    chomp $test;

    next if $test =~ m/^#/;
    my ($subj, $token_str) = split '\:\:', $test;
    chomp $token_str;
    my @tokens;
    foreach my $i (split ",", $token_str) { push @tokens, split '\-\-', $i; }

    my $test_str = &get_tokenized_subject ($subj);
    my $expected_str = &tokensToStr(@tokens);
    if(!ok(is($test_str, $expected_str))) 
    {
       print STDERR "Failed tokenizing subject:[$subj]\n";
    }
  }

  close TSUB;
  done_testing();

sub get_tokenized_subject {
   my ($subj) = @_;

   my @tokens; 
   foreach my $i (&AstroSemantics::Tokenizer::tokenize($subj)) { 
      push @tokens, split '\-\-', $i; 
   }
   return &tokensToStr(@tokens);
}

sub tokensToStr {
   my (@arr) = @_;

   my @tokens = (uniq sort {lc($a) cmp lc($b) } @arr );

#   print STDERR "GOT TOKENS :",join "|", @tokens, "\n";
   my $str = "";
   foreach my $t (0 .. $#tokens) 
   {
      my $token = $tokens[$t];
      if (!$token eq "") 
      {
         $str .= $token;
         $str .= "--";# unless $t == $#tokens;
      }
   }
#   if ($#tokens > 0) {
#     $str = join '--', @tokens;
     chop $str; chop $str; 
#   }
   return $str;
}

1;
