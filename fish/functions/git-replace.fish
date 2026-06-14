function git-replace --description "Find and replace text across git repository with stats"
    # Check for required arguments
    if test (count $argv) -lt 2
        echo "Usage: git-replace SEARCH REPLACE [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --dry-run, -n    Show what would be changed without making changes"
        echo "  --case-sensitive Use case-sensitive search (default: case-insensitive)"
        echo "  --path PATTERN   Limit to files matching pattern"
        echo ""
        echo "Example: git-replace 'old_function' 'new_function'"
        echo "Example: git-replace 'TODO: fix this' 'DONE' --dry-run"
        echo "Example: git-replace 'foo' 'bar' --path '*.js'"
        return 1
    end

    set -l search_term $argv[1]
    set -l replace_term $argv[2]
    set -l dry_run false
    set -l case_sensitive false
    set -l path_pattern ""

    # Parse options (starting from index 3)
    set -l i 3
    while test $i -le (count $argv)
        switch $argv[$i]
            case --dry-run -n
                set dry_run true
            case --case-sensitive
                set case_sensitive true
            case --path
                set i (math $i + 1)
                if test $i -le (count $argv)
                    set path_pattern $argv[$i]
                end
        end
        set i (math $i + 1)
    end

    # Make sure we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    # Find files containing the search term - build command array instead of string
    set -l grep_args -l -F
    if test $case_sensitive = false
        set -a grep_args -i
    end
    set -a grep_args -- $search_term

    if test -n "$path_pattern"
        set -a grep_args -- $path_pattern
    end

    # Find files containing the search term
    set -l files (git grep $grep_args 2>/dev/null)

    if test (count $argv) -eq 0
        echo "No matches found for '$search_term'"
        return 0
    end

    # Initialize counters
    set -l total_files 0
    set -l total_matches 0
    set -l total_lines_changed 0

    # Display header
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if test $dry_run = true
        echo "🔍 DRY RUN - No changes will be made"
    else
        echo "🔄 Replacing '$search_term' with '$replace_term'"
    end
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Process each file
    for file in $files
        # Count matches in this file - use -F for fixed string matching
        set -l count_args -c -F -- $search_term $file
        if test $case_sensitive = false
            set count_args -c -F -i -- $search_term $file
        end

        set -l matches_in_file (grep $count_args 2>/dev/null; or echo 0)

        if test $matches_in_file -gt 0
            set total_files (math $total_files + 1)
            set total_matches (math $total_matches + $matches_in_file)

            # Show preview of changes
            echo "📄 $file ($matches_in_file match"(test $matches_in_file -gt 1; and echo "es"; or echo)")"

            if test $dry_run = false
                # Perform the replacement using perl for cross-platform compatibility
                # Use a Perl script that reads from stdin to avoid shell escaping issues
                set -l perl_script '
                    use strict;
                    use warnings;
                    my ($search, $replace, $case_sensitive) = @ARGV[0..2];
                    local $/;
                    my $content = <STDIN>;
                    if ($case_sensitive eq "0") {
                        $content =~ s/\Q$search\E/$replace/gi;
                    } else {
                        $content =~ s/\Q$search\E/$replace/g;
                    }
                    print $content;
                '

                set -l case_flag 0
                if test $case_sensitive = true
                    set case_flag 1
                end

                # Create a temporary file for the replacement
                set -l tmp_file (mktemp)
                cat $file | perl -e $perl_script -- $search_term $replace_term $case_flag >$tmp_file
                mv $tmp_file $file

                # Count lines changed in this file
                set -l lines_changed (git diff --numstat $file 2>/dev/null | awk '{print $1 + $2}')
                if test -n "$lines_changed"
                    set total_lines_changed (math $total_lines_changed + $lines_changed)
                end
            else
                # Show a preview of the changes
                set -l preview_args -n -F -- $search_term $file
                if test $case_sensitive = false
                    set preview_args -n -F -i -- $search_term $file
                end

                set -l preview_count 0
                grep $preview_args | while read -l line
                    set preview_count (math $preview_count + 1)
                    if test $preview_count -le 3
                        echo "  $line"
                    else if test $preview_count -eq 4
                        echo "  ... (and more)"
                        break
                    end
                end
            end
            echo ""
        end
    end

    # Display summary statistics
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 Summary:"
    echo "   Files affected:    $total_files"
    echo "   Total matches:     $total_matches"

    if test $dry_run = false
        echo "   Lines changed:     $total_lines_changed"
        echo ""
        echo "✅ Replacement complete!"
        echo "💡 Tip: Review changes with 'git diff' and commit when ready"
    else
        echo ""
        echo "💡 Run without --dry-run to apply changes"
    end
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end

