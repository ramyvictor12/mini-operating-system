/*
 * dyn_block_management.c
 *
 *  Created on: Sep 21, 2022
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
	cprintf("\n=========================================\n");

}

//********************************************************************************//
//********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
		{
			if(tmp->sva==va)
			{
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;

		//struct MemBlock *tmp;

//		LIST_FOREACH(tmp ,&blockList)
//		{
//			if(tmp->sva==va)
//		{
//						return tmp;
//
//		}
//
//		}
//			return tmp;
}

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
		{
			if(blockToInsert->sva<tmp->sva)
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
	{
		if(size==(tmp->size))
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);

			return tmp;

		}
		else if(size<tmp->size)
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
			 newBlock->size=size;
			 newBlock->sva=tmp->sva;
			 tmp->size=tmp->size-size;
			 tmp->sva=tmp->sva+size;

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
}

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
		{
			if(size==(tmp->size))
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
				return tmp;

			}
			else if (tmp->size<newSize&&tmp->size>size)
			{
				newSize=tmp->size;


			}
			tmp=tmp->prev_next_info.le_next;
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
			{
				if(tmp->size==newSize)
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
								 newBlock->size=size;

											 tmp->sva+=size;
											 tmp->size-=size;
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
											 return newBlock;

					}
				tmp=tmp->prev_next_info.le_next;
			}
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
	}



//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
	{
		tmp1=alloc_block_FF(size);
		return tmp1;
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
			}


do
	{

		if(size==(tmp1->size))
				{
			currentSva=tmp1->size+tmp1->sva;
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
					return tmp1;

				}
				else if(size<tmp1->size)
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
					 newBlock->size=size;
					 newBlock->sva=tmp1->sva;
					 tmp1->sva+=size;
					 tmp1->size-=size;
                     currentSva=tmp1->sva;

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
					 return newBlock;

				}
		if(tmp1==FreeMemBlocksList.lh_last)
			tmp1=FreeMemBlocksList.lh_first;
		else
				tmp1=tmp1->prev_next_info.le_next;


			}
while(tmp1->sva!=currentSva);

			return NULL;

	}


//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
		blockToInsert->size=0;
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
		blockToInsert->sva=0;
		blockToInsert->size=0;

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
				break;
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
			{
tmp->sva=blockToInsert->sva;
tmp->size+=blockToInsert->size;
blockToInsert->sva=0;
blockToInsert->size=0;
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
break;
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
				ptr->size+=blockToInsert->size;
				blockToInsert->sva=0;
				blockToInsert->size =0;
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
break;
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
				tmp->size=0;
				tmp->sva=0;
				LIST_REMOVE(&FreeMemBlocksList,tmp);
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
				blockToInsert->sva=0;
				blockToInsert->size=0;
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
				break;
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
		}

	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}




