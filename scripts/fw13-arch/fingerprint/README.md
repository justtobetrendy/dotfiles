## Howto update fingerprint reader firmware and enable fingerprint on Gnome

### Firmware update

Based on the Framework KB Article [Updating Fingerprint Reader Firmware on Linux for all Framework Laptops](https://knowledgebase.frame.work/en_us/updating-fingerprint-reader-firmware-on-linux-for-13th-gen-and-amd-ryzen-7040-series-laptops-HJrvxv_za)

Check the current version:

```
sh 01-fprintdriver-check.sh
```

Update the driver:  

```
sh 02-fprintdriver-update.sh
```

### To activate fingerprint in Gnome

Install `fprintd`:

```
sudo pacman -S fprintd
```

Then goto user and register fingerprints.
