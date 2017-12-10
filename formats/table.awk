BEGIN {
    print "#List\tURL\tComment"
}

{
    printf "%s\t%s\t",$1,$2
    for(i=3; i <= NF; i++)
	printf "%s ",$i
    print ""
}
