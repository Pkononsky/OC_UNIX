#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <string.h>

#define BUFFER_SIZE 512

int main(int argc, char *argv[]) {
	if (argc == 1) {
    	printf("%s\n", "Введите имя файла");			
    	return 1;
	}

    int fd = open(argv[1], O_WRONLY|O_CREAT, 0640);

    if (fd == -1) {
    	printf("%s\n", "Ошибка при открытии/создании файла");
    	return 1;
    }

    // Буфер для записи в файл
    char buf_2_write[BUFFER_SIZE];
    // Буфер для чтения из потока
    char buf_2_read[BUFFER_SIZE];
    // счетчик байтов для записи
    int bytes_2_write = 0;
    int zeros = 0;
    int i = 0;
	int readed = 0;

    while (readed = read(0, buf_2_read, BUFFER_SIZE)) {
    	while(i < readed) {
    		// пока не встретим \0 запоминаем блок символов
    		while(buf_2_read[i] != 0 && i < readed) {
    			buf_2_write[bytes_2_write] = buf_2_read[i];
    			bytes_2_write++;
    			i++;
    		}
    		// считаем все \0 после до следующего блока с текстом
    		while(buf_2_read[i] == 0 && i < readed) {
    			zeros++;
    			i++;
    		}
    		// записываем блок символов (если он не пустой)
    		if (bytes_2_write != 0) {
		    	write(fd, buf_2_write, bytes_2_write);
		    	bytes_2_write = 0;
    		}
    		// делаем lseek на количество нулей
    		if (zeros != 0) {	
    			lseek(fd, zeros, SEEK_CUR);
    			zeros = 0;
    		}
    		// повторяем пока не закончился блок размером BUFFER_SIZE
    		// если блок кончился читаем следующий, либо выходим
    	}

    	i = 0;
    }

    close(fd);

    return 0;
}