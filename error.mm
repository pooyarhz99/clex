/*==============================================================================
Error handling library. */

static struct
{	struct
	{	uint64_t line_number;
		uint64_t column_number;
		const_zstr error_message;
		
	} *error_list;
	size_t error_count;

} error_log = {
	(typeof(*error_log.error_list)*)calloc(ALLOCATION_SIZE, sizeof(*error_log.error_list)),
	0
};

static void RaiseError(uint64_t line_number, uint64_t column_number, const_zstr error_message)
{	if (error_log.error_count < ALLOCATION_SIZE)
	{	size_t i = error_log.error_count;
		error_log.error_list[i].line_number   = line_number;
		error_log.error_list[i].column_number = column_number;
		error_log.error_list[i].error_message = error_message;
		error_log.error_count++;
	}
	else
	{	printf("Error: error log ran out of memory, increase its size.\n");
	}
}
