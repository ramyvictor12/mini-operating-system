/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include "kheap.h"
#include "memory_manager.h"


/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 num_of_pages)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] cut_paste_pages
	// Write your code here, remove the panic and write your code
	//panic("cut_paste_pages() is not implemented yet...!!");
	ROUNDDOWN(source_va,4);
	ROUNDUP(dest_va,4);
	uint32 j=0,*ptr_page_table3=NULL;
	for(uint32 i=0;i<num_of_pages;i++)
	{
		int ret=get_page_table(page_directory,dest_va+j,&ptr_page_table3);
		struct FrameInfo*info1 =get_frame_info(page_directory,dest_va+j,&ptr_page_table3);
		if(info1!=0)
			return -1;
		j+=(4*1024);

	}
	j=0;

for (uint32 i=0;i<num_of_pages;i++)
{
	uint32 *ptr_page_table1=NULL,*ptr_page_table2=NULL;
	int ret1=get_page_table(page_directory,source_va+j,&ptr_page_table1);
	int ret2=get_page_table(page_directory,dest_va+j,&ptr_page_table2);
	struct FrameInfo*info2 =get_frame_info(page_directory,source_va+j,&ptr_page_table1);
if(ret2==TABLE_IN_MEMORY)
{

		map_frame(page_directory,info2,dest_va+j,ptr_page_table1[PTX(source_va+j)]&4095);
		unmap_frame(page_directory,source_va+j);


}
else
{
	ptr_page_table2=create_page_table(page_directory,dest_va+j);
	map_frame(page_directory,info2,dest_va+j,ptr_page_table1[PTX(source_va+j)]&4095);
			unmap_frame(page_directory,source_va+j);

}
j+=(4*1024);
}
return 0;

}

//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 size)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] copy_paste_chunk
	// Write your code here, remove the panic and write your code
	//panic("copy_paste_chunk() is not implemented yet...!!");

	    uint32 tmp=source_va;
		uint32 dest=dest_va;
		uint32 endAdress=dest+size;
uint32 sourceEnd=tmp+size;


		while(dest<endAdress)// with read only pages
		{

			uint32 *ptr_page_table3=NULL;
			int ret=get_page_table(page_directory,dest,&ptr_page_table3);
struct FrameInfo *info=get_frame_info(page_directory,dest,&ptr_page_table3);
if(info!=0)
			{
	if((pt_get_page_permissions(page_directory,dest)&PERM_WRITEABLE)==0)
				return -1;
			}
dest+=PAGE_SIZE;

		}

dest=dest_va;

		while(tmp<sourceEnd)// loop for  writable  pages
				{
			uint32 *ptr_page_table1=NULL;
			int ret1=get_page_table(page_directory,dest,&ptr_page_table1);//destination
char *s,*d;

			if(ret1!=TABLE_IN_MEMORY)

			{


				ptr_page_table1=create_page_table(page_directory,dest);
				struct FrameInfo* newFrame=NULL;
				allocate_frame(&newFrame);

				int prm1=pt_get_page_permissions(page_directory,tmp);
				pt_set_page_permissions(page_directory,dest,(prm1&PERM_USER)|PERM_WRITEABLE,0);
				map_frame(page_directory,newFrame,dest,(prm1&PERM_USER)|PERM_WRITEABLE);

			}
			else if(ret1==TABLE_IN_MEMORY&&ptr_page_table1[PTX(dest)]==0)
			{
				struct FrameInfo* newFrame1=NULL;
								allocate_frame(&newFrame1);

								int prm2=pt_get_page_permissions(page_directory,tmp);
								pt_set_page_permissions(page_directory,dest,(prm2&PERM_USER)|PERM_WRITEABLE,0);
								map_frame(page_directory,newFrame1,dest,(prm2&PERM_USER)|PERM_WRITEABLE);

			}
					 s=(char *)tmp;
					 d=(char *)dest;


			for (uint32 i=0x0;i<PAGE_SIZE;i++)
									{
				if(dest_va+size==i+(uint32)d)
					break;
									d[i]=s[i];
							}

								tmp+=PAGE_SIZE;
								dest+=PAGE_SIZE;

							}

		return 0;
		}










//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should share the given size from dest_va with the source_va
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int share_chunk(uint32* page_directory, uint32 source_va,uint32 dest_va, uint32 size, uint32 perms)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] share_chunk
	// Write your code here, remove the panic and write your code
	//panic("share_chunk() is not implemented yet...!!");
	uint32 source=ROUNDDOWN( source_va,PAGE_SIZE);
	uint32 dest=ROUNDDOWN(dest_va,PAGE_SIZE);

	uint32 endSource=ROUNDUP(source_va+size,PAGE_SIZE);
	uint32 endAddress=ROUNDUP(dest_va+size,PAGE_SIZE);
	while(dest<endAddress)
	{
		uint32 *ptr_page_table=NULL;
		int ret=get_page_table(page_directory,dest,&ptr_page_table);
		struct FrameInfo*info1 =get_frame_info(page_directory,dest,&ptr_page_table);
		if(info1!=0)
			return -1;
		dest+=PAGE_SIZE;

	}
	dest=ROUNDDOWN(dest_va,PAGE_SIZE);


while(source<endSource)
{
	uint32 *ptr_page_table1=NULL,*ptr_page_table2=NULL;
	int ret1=get_page_table(page_directory,source,&ptr_page_table1);//page table of source
	int ret2=get_page_table(page_directory,dest,&ptr_page_table2);//page table of destination
	struct FrameInfo*info2 =get_frame_info(page_directory,source,&ptr_page_table1);
if(ret2==TABLE_IN_MEMORY)
{
	map_frame(page_directory,info2,dest,perms);
}
else
{
	ptr_page_table2=create_page_table(page_directory,dest);
	map_frame(page_directory,info2,dest,perms);


}
source+=PAGE_SIZE;
dest+=PAGE_SIZE;
}
return 0;
}

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate in RAM the given range [va, va+size)
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] allocate_chunk
	// Write your code here, remove the panic and write your code
	//panic("allocate_chunk() is not implemented yet...!!");
	  uint32 tmp=ROUNDDOWN(va,PAGE_SIZE);
	  uint32 endAdress=va+size;
	  uint32 sourceEnd=tmp+size;


			while(tmp<endAdress)// with read only pages
			{

				uint32 *ptr_page_table=NULL;
				int ret=get_page_table(page_directory,tmp,&ptr_page_table);
	struct FrameInfo *info=get_frame_info(page_directory,tmp,&ptr_page_table);
	if(info!=0)
				{
					return -1;
				}
	tmp+=PAGE_SIZE;

			}
			tmp=ROUNDDOWN(va,PAGE_SIZE);
			while(tmp<endAdress)
			{
				uint32 *ptr_page_table1=NULL;
				int ret1=get_page_table(page_directory,tmp,&ptr_page_table1);
if(ret1!=TABLE_IN_MEMORY)
{
	ptr_page_table1=create_page_table(page_directory,tmp);
					struct FrameInfo* newFrame=NULL;
					allocate_frame(&newFrame);
        map_frame(page_directory,newFrame,tmp,perms);
        newFrame->va=tmp;
}
else
{
	struct FrameInfo* newFrame1=NULL;
					allocate_frame(&newFrame1);
        map_frame(page_directory,newFrame1,tmp,perms);
        newFrame1->va=tmp;
}
tmp+=PAGE_SIZE;
			}
			return 0;
}

/*BONUS*/
//=====================================
// 5) CALCULATE ALLOCATED SPACE IN RAM:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva, uint32 *num_tables, uint32 *num_pages)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_allocated_space
	// Write your code here, remove the panic and write your code
	//panic("calculate_allocated_space() is not implemented yet...!!");
	uint32 source= ROUNDDOWN(sva,PAGE_SIZE);
	uint32 dest=ROUNDUP(eva,PAGE_SIZE);
	*num_pages=0;
	*num_pages=0;
	while(source<=dest)
	{
		uint32 *ptr_page_table1=NULL,*ptr_page_table2=NULL;
		int ret1 =get_page_table(page_directory,source,&ptr_page_table1);
		int ret2 =get_page_table(page_directory,source+PAGE_SIZE,&ptr_page_table2);

		struct FrameInfo *info=get_frame_info(page_directory,source,&ptr_page_table1);
		if(info!=0)
			{
			(*num_pages)++;
			}

		if(ret1==TABLE_IN_MEMORY&&ret2==TABLE_IN_MEMORY&&PDX(source)!=PDX(source+PAGE_SIZE))
			(*num_tables)+=2;
		else if(ret1==TABLE_IN_MEMORY&&ret2!=TABLE_IN_MEMORY)
		{
			(*num_tables)++;
		}


	source+=PAGE_SIZE;
	if(source==dest&&ret1==TABLE_IN_MEMORY)
		(*num_tables)++;

	}
}

/*BONUS*/
//=====================================
// 6) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
// calculate_required_frames:
// calculates the new allocation size required for given address+size,
// we are not interested in knowing if pages or tables actually exist in memory or the page file,
// we are interested in knowing whether they are allocated or not.
uint32 calculate_required_frames(uint32* page_directory, uint32 sva, uint32 size)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_required_frames
	// Write your code here, remove the panic and write your code
	//panic("calculate_required_frames() is not implemented yet...!!");


	uint32 *ptr_page_table1;
	const uint32  TABLE_SIZE = PAGE_SIZE * 1024;
	uint32 current_virtual_address_tables = ROUNDDOWN(sva,TABLE_SIZE);
    uint32 n=sva+size;


uint32 requiredTables=0;
		while(current_virtual_address_tables<n){



			if(get_page_table(page_directory,  current_virtual_address_tables, &ptr_page_table1)==TABLE_NOT_EXIST)
			{
				(requiredTables)++;
			}
			current_virtual_address_tables+=TABLE_SIZE;
		}
		uint32  current_virtual_address_pages = ROUNDDOWN(sva, PAGE_SIZE);

		uint32 requiredPages=0;
		while(current_virtual_address_pages<n){

			if ((get_frame_info(page_directory,current_virtual_address_pages,&ptr_page_table1)) == NULL)
			{
				(requiredPages)++;
			}
			current_virtual_address_pages+=PAGE_SIZE;
		}



	//calc the required page frames


	//return total number of frames

	return (requiredTables+requiredPages);
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================

//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	// Write your code here, remove the panic and write your code
	panic("allocate_user_mem() is not implemented yet...!!");
}

//=====================================
// 2) FREE USER MEMORY:
//=====================================
void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3] [USER HEAP - KERNEL SIDE] free_user_mem
	// Write your code here, remove the panic and write your code
	//panic("free_user_mem() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	uint32 n=ROUNDUP(size,PAGE_SIZE)/PAGE_SIZE;//number of pages
	uint32 	va=ROUNDDOWN(virtual_address,PAGE_SIZE);

	for(uint32 i=0;i<n;i++)
	{

		pf_remove_env_page(e,va);
		va+=PAGE_SIZE;
	}
	//2. Free ONLY pages that are resident in the working set from the memory
	va=ROUNDDOWN(virtual_address,PAGE_SIZE);
	uint32 wsSize=e->page_WS_max_size;
	for (uint32 i=0;i<wsSize;i++)
	{
		uint32 currentVa=env_page_ws_get_virtual_address(e,i);
		uint32 sizeOfva=va+ROUNDUP(size,PAGE_SIZE);
		uint32 * ptr_page_table=NULL;
		get_page_table(e->env_page_directory,currentVa,&ptr_page_table);
		if(currentVa>=va&&currentVa<sizeOfva)
		{
			env_page_ws_clear_entry(e,i);
			unmap_frame(e->env_page_directory,currentVa);

		}
	}
	//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
	va=ROUNDDOWN(virtual_address,PAGE_SIZE);
	 uint32 *ptr_page_table;
	for(int i=0; i<n; i++)
	{
	    ptr_page_table=NULL;
		int ret =get_page_table(e->env_page_directory,va,&ptr_page_table);
		int check=1;
		if(ret==TABLE_IN_MEMORY)
		{
		for(int j=0;j<1024;j++)//loop on entries of page table
		{
			if(ptr_page_table[j]!=0)
			{
				check =0;
				break;
			}
		}

		}
		if(check)
				{
					kfree((void*)ptr_page_table);
					pd_clear_page_dir_entry(e->env_page_directory,va);
				}
		va+=PAGE_SIZE;
	}
	tlbflush();
}

//=====================================
// 2) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address, uint32 size)
{
	// your code is here, remove the panic and write your code
	panic("__free_user_mem_with_buffering() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Free any BUFFERED pages in the given range
	//4. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - KERNEL SIDE] move_user_mem
	//your code is here, remove the panic and write your code
	panic("move_user_mem() is not implemented yet...!!");

	// This function should move all pages from "src_virtual_address" to "dst_virtual_address"
	// with the given size
	// After finished, the src_virtual_address must no longer be accessed/exist in either page file
	// or main memory

	/**/
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//

