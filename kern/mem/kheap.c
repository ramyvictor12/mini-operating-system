#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

//==================================================================//
//==================================================================//
//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)//
//==================================================================//
//==================================================================//

void initialize_dyn_block_system()
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] initialize_dyn_block_system
		// your code is here, remove the panic and write your code
		//kpanic_into_prompt("initialize_dyn_block_system() is not implemented yet...!!");

		//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
		LIST_INIT(&AllocMemBlocksList);
		LIST_INIT(&FreeMemBlocksList);

		#if STATIC_MEMBLOCK_ALLOC
		//DO NOTHING
	#else
		/*[2] Dynamically allocate the array of MemBlockNodes
		 * 	remember to:
		 * 		1. set MAX_MEM_BLOCK_CNT with the chosen size of the array
		 * 		2. allocation should be aligned on PAGE boundary
		 * 	HINT: can use alloc_chunk(...) function
		 */
		MAX_MEM_BLOCK_CNT=NUM_OF_KHEAP_PAGES;

		uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_KHEAP_PAGES;// array space in heap
		MemBlockNodes=(struct MemBlock*)KERNEL_HEAP_START;//casting to point to the heap


		allocate_chunk(ptr_page_directory,KERNEL_HEAP_START,requiredSpace,PERM_WRITEABLE);

	#endif
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
	struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
	freeSva->size=(KERNEL_HEAP_MAX-KERNEL_HEAP_START)-requiredSpace;
	freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);

	freeSva->sva=KERNEL_HEAP_START+requiredSpace;
	freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);




	LIST_REMOVE(&AvailableMemBlocksList,freeSva);
	insert_sorted_with_merge_freeList(freeSva);


		//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
		//[4] Insert a new MemBlock with the remaining heap size into the FreeMemBlocksList
}

void* kmalloc(unsigned int size)
{
	{
		//TODO: [PROJECT MS2] [KERNEL HEAP] kmalloc
			// your code is here, remove the panic and write your code
			//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
		if(size>KERNEL_HEAP_MAX-KERNEL_HEAP_START)// boundries of heap
						return NULL;
			struct MemBlock *ret=NULL;
			size=ROUNDUP(size,PAGE_SIZE);

//check the strategy
		if(isKHeapPlacementStrategyFIRSTFIT())
		{

			ret=alloc_block_FF(size);


		}
		else
		{

			ret=alloc_block_BF(size);

		}
			//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)
			//refer to the project presentation and documentation for details

		// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy
		int allocated_chunk;
		if(ret!=NULL){
			 allocated_chunk=allocate_chunk(ptr_page_directory,ret->sva,size,PERM_WRITEABLE);
		if(allocated_chunk!=0)
			return NULL;
		else
		{
		insert_sorted_allocList(ret);
		return (void *)ret->sva;
		}
		}
		else{
			return NULL;
		}

			//change this "return" according to your answer
	}
}

	//change this "return" according to your answer


void kfree(void* virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kfree
	// Write your code here, remove the panic and write your code
	//panic("kfree() is not implemented yet...!!");

	struct MemBlock * returnBlock=find_block(&AllocMemBlocksList,(uint32)virtual_address);
	if(returnBlock!=NULL)
	{
		LIST_REMOVE(&AllocMemBlocksList,returnBlock);
uint32 x=ROUNDDOWN(returnBlock->sva,PAGE_SIZE);
uint32 y=ROUNDUP(returnBlock->sva+returnBlock->size,PAGE_SIZE);
for (uint32 i=x;i<y;i+=PAGE_SIZE)
	unmap_frame(ptr_page_directory,i);
insert_sorted_with_merge_freeList( returnBlock); //add block to right place in freelist
	}





}
unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_virtual_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_virtual_address() is not implemented yet...!!");
struct FrameInfo *info =to_frame_info(physical_address);
return info->va;


	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details
	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_physical_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_physical_address() is not implemented yet...!!");
		uint32* ptr_page_table = NULL;
		get_page_table(ptr_page_directory, virtual_address, &ptr_page_table);

		return (ptr_page_table[PTX(virtual_address)]>>12) * PAGE_SIZE;

// or we just call the function virtual to physical
	//virtual_to_physical(ptr_page_directory,virtual_address);


}




void kfreeall()
{
	panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
	panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
	panic("Not implemented!");
}




//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT MS2 - BONUS] [KERNEL HEAP] krealloc
	// Write your code here, remove the panic and write your code
	panic("krealloc() is not implemented yet...!!");
}
