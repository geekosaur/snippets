syscall::write:return
/execname == "gcc" && args[0] == 2/
{
	printf("%s", stringof(copyin(arg1, arg2)));
}
