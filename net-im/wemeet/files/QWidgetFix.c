#include <stdbool.h>
#include <stdint.h>

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>

#include <sys/ucontext.h>
#include <ucontext.h>

static void __attribute__ ((constructor)) init_lib(void);

void setHandler(void (*handler)(int,siginfo_t *,void *))
{
	struct sigaction action;
	action.sa_flags = SA_SIGINFO;
	action.sa_sigaction = handler;

	if (sigaction(SIGFPE, &action, NULL) == -1) {
		perror("sigusr: sigaction");
		_exit(1);
	}
	if (sigaction(SIGSEGV, &action, NULL) == -1) {
		perror("sigusr: sigaction");
		_exit(1);
	}
	if (sigaction(SIGILL, &action, NULL) == -1) {
		perror("sigusr: sigaction");
		_exit(1);
	}
	if (sigaction(SIGBUS, &action, NULL) == -1) {
		perror("sigusr: sigaction");
		_exit(1);
	}

}

int n[2097152];

void catchit(int signo, siginfo_t *info, void *extra) 
{
	ucontext_t *p=(ucontext_t *)extra;
	int x;
	printf("Signal %d received\n", signo);
	printf("siginfo address=%x\n",info->si_addr);

	x= p->uc_mcontext.gregs[REG_RIP];

	printf("address = %x\n",x);

    p->uc_mcontext.gregs[REG_RAX] = &n;

	// setHandler(SIG_DFL);

}


void init_lib()
{
	setHandler(catchit);
}

extern int _ZN7QObject11eventFilterEPS_P6QEvent(void *o, void *e);
/* QWidget::setPaintsEnabled(bool) */
int _ZN7QWidget16setPaintsEnabledEb(bool b) {
    return b || 1;
}
/* QWidget::eventFilter(QObject*, QEvent*) */
int _ZN7QWidget11eventFilterEP7QObjectP6QEvent(void *o, void *e) {
    return _ZN7QObject11eventFilterEPS_P6QEvent(o,e);
}
/* QLabel::eventFilter(QObject*, QEvent*) */
int _ZN6QLabel11eventFilterEP7QObjectP6QEvent(void *o, void *e) {
    return _ZN7QObject11eventFilterEPS_P6QEvent(o,e);
}
/* QAction::eventFilter(QObject*, QEvent*) */
int _ZN7QAction11eventFilterEP7QObjectP6QEvent(void *o, void *e) {
    return _ZN7QObject11eventFilterEPS_P6QEvent(o,e);
}
/* QAbstractButton::eventFilter(QObject*, QEvent*) */
int _ZN15QAbstractButton11eventFilterEP7QObjectP6QEvent(void *o, void *e) {
    return _ZN7QObject11eventFilterEPS_P6QEvent(o,e);
}
