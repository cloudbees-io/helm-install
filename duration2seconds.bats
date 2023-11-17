#!/usr/bin/env bats

export PATH="`pwd`:$PATH"

assertDurationConversion() {
	SECONDS="$(duration2seconds.sh "$1")"
	[ "$SECONDS" = "$2" ] || (echo "Expected $2 but was $SECONDS" >&2; false)
}

@test 'duration2seconds with empty arg returns 0' {
	assertDurationConversion '' 0
}

@test 'duration2seconds 2s' {
	assertDurationConversion 2s 2
}

@test 'duration2seconds 2m' {
	assertDurationConversion 2m 120
}

@test 'duration2seconds 2h' {
	assertDurationConversion 2h 7200
}

@test 'duration2seconds 1h0m0s' {
	assertDurationConversion 1h0m0s 3600
}

@test 'duration2seconds 1h5m3s' {
	assertDurationConversion 1h5m3s 3903
}

@test 'duration2seconds 1h0m' {
	assertDurationConversion 1h0m 3600
}

@test 'duration2seconds 5m0s' {
	assertDurationConversion 5m0s 300
}

@test 'duration2seconds should fail when unit missing' {
	! duration2seconds.sh 30
}

@test 'duration2seconds should fail on invalid duration format' {
	! duration2seconds.sh "5m0x"
}

@test 'duration2seconds should fail on trailing characters' {
	! duration2seconds.sh "1h5m1s0x"
}

@test 'duration2seconds should fail on leading characters' {
	! duration2seconds.sh "0x1h5m1s"
}
