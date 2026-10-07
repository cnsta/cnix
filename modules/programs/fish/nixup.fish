function nixup -d "Rebuild NixOS: 'delta' updates delta and river first"
    switch "$argv"
        case ''
            nh os switch -d always -H $hostname

        case delta
            # river follows into river-delta, so both move together.
            nix flake update --flake "$NH_FLAKE" river-delta river
            or return

            # A new river or delta restarts the session unit, which would take
            # this terminal (and nh) with it, run the switch outside the session.
            sudo systemd-run --collect --pipe --wait \
                nh os switch "$NH_FLAKE" -d always -H $hostname

        case '*'
            echo "nixup: unknown target '$argv'" >&2
            echo "usage: nixup [delta]" >&2
            return 2
    end
end
