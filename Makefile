bucket=10208-fcd9acb029f419e6493edf97f4592b96
folder=resslab
quality=80

jpgs=$(wildcard photos/*.jpg)
webps=$(jpgs:.jpg=.webp)

help:
	@echo s3://${bucket}/${folder}/

# Convert every photos/*.jpg to photos/*.webp (only when missing or older than the jpg)
webp: $(webps)

photos/%.webp: photos/%.jpg
	cwebp -quiet -q $(quality) -metadata none $< -o $@

upload-photos:
	s3cmd put --recursive --acl-public --guess-mime-type photos s3://${bucket}/${folder}/virtual_tour/

download-photos:
	mkdir -p photos-cdn
	s3cmd get --recursive s3://${bucket}/${folder}/virtual_tour/photos/ photos-cdn/

.PHONY: help webp upload-photos
