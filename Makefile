DRAFT:=opsawg-mud-iot-dns-considerations
VERSION:=$(shell ./getver ${DRAFT}.md )

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

%.xml: %.md
	kramdown-rfc2629 ${DRAFT}.md >${DRAFT}.v2.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --v2v3 ${DRAFT}.v2.xml
	mv ${DRAFT}.v2.v2v3.xml ${DRAFT}.xml
	: git add ${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --text -o $@ $?

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	curl --http1.1 -S -F "user=mcr+ietf@sandelman.ca" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submission | jq

version:
	echo Version: ${VERSION}

clean:
	-rm -f ${DRAFT}.xml ${CWTDATE1} ${CWTDATE2}

.PRECIOUS: ${DRAFT}.xml
