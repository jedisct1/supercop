all: inner32.s

inner32.s: inner32.q copy-collector align
	qhasm-arm-m4 < inner32.q | ./copy-collector | ./align > inner32.s

inner32.q: inner.q inner32.desc inner32.q.do inner32.top
	sh inner32.q.do > inner32.q
