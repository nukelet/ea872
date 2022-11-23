#include <stdio.h>

main()
{
int pid;
	printf("pid(processo)=%d, pid(processo-pai)=%d\n",getpid(),getppid());
	pid = fork();
	if (pid == 0)
	{
		printf("\nProcesso-filho:\n");
		printf("pid(processo-filho)=%d, pid(processo-pai)=%d\n",getpid(),getppid());
		sleep(6);
		printf("...apos aproximadamente 6 segundos...\n");
		printf("pid(processo-filho)=%d, pid(processo-pai)=%d\n",getpid(),getppid());
	}
	else
	{
		printf("\nProcesso-pai:\n");
		printf("pid(processo-filho)=%d\n",pid);
		sleep(1);
		printf("...apos aproximadamente 1 segundo...\n");
	}
	printf ("Processo %d terminou!\n\n",getpid());
}


