Pour tester, assemble de petits programmes avec arm-none-eabi-as (ou aarch64-none-elf-as selon ta cible), extrais un binaire brut avec objcopy -O binary, puis exécute-le dans ton émulateur. Commence par mov, add, b, puis ldr/str.

CIBLE="Ta cible est donc de l'ARM 32 bits, pas de l'AArch64 : pour tes tests, l'outillage est arm-none-eabi-* avec -mcpu=arm1176jzf-s. Côté jeu d'instructions, tu as l'ARM 32 bits et le Thumb 16 bits, mais pas Thumb-2"

Pour t'ancrer, voici la traduction réflexe de tes habitudes C :

malloc / free → un allocateur en paramètre + defer
return -1 / errno → return error.Quelquechose + try
NULL → ?T et orelse
char * + strlen → []const u8
#define → const ou comptime
goto cleanup → defer / errdefer

Pour les emplacements dans le PDF, la table des matières indique Mini UART (§2.2, p.10), GPIO (§6, p.89), System Timer (§12, p.172), UART (§13, p.175) et Timer côté ARM (§14, p.196). Elle contient aussi de nombreuses erreurs connues : cherche "BCM2835 datasheet errata" sur elinux.org et garde la page ouverte à côté.
data=https://pip-assets.raspberrypi.com/categories/579-raspberry-pi-zero/documents/RP-008249-DS-1-bcm2835-peripherals.pdf

À noter : sur le vrai Pi, le GPU démarre le premier et charge le kernel en RAM avant de lancer l'ARM, tu n'as donc rien à émuler de ce côté-là : charge ton binaire à 0x8000 et saute dessus.

ressource incroyable pour les périf et le kernel https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/ok01.html

pour voir l'asm après compil https://godbolt.org/

doc built-in zig https://ziglang.org/documentation/0.17.0/#ctz

super tuto project based : https://pedropark99.github.io/zig-book/Chapters/01-base64.html

Oui, le Broadcom BCM2835 (utilisé notamment dans le premier Raspberry Pi et le Raspberry Pi Zero à 1 GHz) intègre un processeur graphique (GPU).
Caractéristiques du GPU
• Modèle : Broadcom VideoCore IV.
• Capacités : Prise en charge d'OpenGL ES 2.0 (graphismes 3D), OpenVG (accélération matérielle 2D) et décodage vidéo H.264 en qualité 1080p à 30 images par seconde.
• Particularité : Sur ce SoC, le VideoCore IV est un composant très puissant par rapport au processeur principal (ARM11), gérant même le démarrage et l'initialisation du système avant le CPU.

produit que je souhaite émuler https://www.kubii.com/en/nano-computers/2076-raspberry-pi-zero-wh-3272496009394.html