org 0h
mov r0, #20 ; jumlah kapasitas dalam gedung ditaro di r0
mov dptr, #200h ; untuk mengakses data1 yang ada di rom
mov a, r0 	
call seven  ;menampilkan kapasitas gedung pertama kali
port_masuk equ p1.0	; input dari sensor masuk di port 1 bit 0
port_keluar equ p1.1	; input dari sensor keluar di port 1 bit 1
sensor_masuk equ p1.2	; untuk mengenable sensor masuk dari port 1 bit 2
sensor_keluar equ p1.3	; untuk mengenable sensor keluar dari port 1 bit 3
seven_segment_1 equ p2	; menampilkan seven segmen 1 menggunakan port 2
seven_segment_2 equ p3	; menampilkan seven segmen 1 menggunakan port 3


check:	mov a, r0 ; fungsi untuk mencek apakah full atau tidak 
	jz full
	jmp pintu ; apabila tidak ke fungsi pintu
		
full:	
	jnb port_keluar, keluar	; akan keluar daru fungsi apabila ada input di sensor keluar
	clr sensor_masuk	; apabila full maka sensor masuk di disable/dimatikan
	jmp check		; loop

kosong: cjne r0, #20, keluar ; untuk menset limit maksimum jumlah pengujung di suatu gedung
	clr sensor_keluar	; mematikan sensor keluar	
	jnb port_masuk, masuk	; akan me loop hingga ada input di sensor masuk
	jmp kosong
	

pintu: setb	sensor_masuk	; meng enable/ menyalakan sensor masuk
	 jnb port_masuk, masuk	; jump ke fungsi masuk apabila ada input
	 setb sensor_keluar	; meng enable/ menyalakan sensor masuk
	jnb port_keluar, kosong	; jump ke fungsi keluar apabila ada input
	jmp check		; balik apabila tidak ada input
	
masuk:	
	 mov a, r0	
	subb a, #1	; mengurangkan kapasitas 
	mov r0, a
	clr cy
	jmp seven	; menampilakan seven segment

keluar:	
	 mov a, r0
	add a, #1	; menambahkan kapasitas
	mov r0, a
	clr cy
	jmp seven	; menampilakan seven segment

seven:	mov b, #10
	div ab		; membagi agar dapat memecah angka puluhan dan satuan
	mov r1, a
	mov r2, b
	movc a, @a+dptr
	cpl a
	mov seven_segment_1, a	; untuk menampilkan angka puluhan
	mov a, r2
	movc a, @a+dptr
	cpl a
	mov seven_segment_2, a	; untuk menampilkan angka satuan
	mov a, #1
	call delay
	jmp check

org 200h
data1: db 192, 249,164,176,153,146,130,248,128,144 	; data untuk menampilkan angka pada seven segment
delay:
	 mov tmod, #10h ; mengaktifkan timer 1
	mov tl1, #0h
 	mov th1, #0h
  	setb tr1
again: jnb tf1, again	; loop hingga timer selesai
    	clr tr1
 	clr tf1
 	add a, #1h
 	cjne a, #5, delay	; loop sebanyak 5 kali agar input sinkron dengan output
 	ret


end 