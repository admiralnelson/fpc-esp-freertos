unit list;

{$include freertosconfig.inc}

interface

uses
  projdefs, portmacro, portable;

(* Macros that can be used to place known values within the list structures,
then check that the known values do not get corrupted during the execution of
the application.   These may catch the list data structures being overwritten in
memory.  They will not catch data errors caused by incorrect configuration or
use of FreeRTOS.*)
(*  Replace with in place implementations rather than macros
{$if defined(configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES) and (configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES =  0)}
	(* Define the macros to do nothing. *)
	{$define listFIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE}
	{$define listSECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE}
	{$define listFIRST_LIST_INTEGRITY_CHECK_VALUE}
	{$define listSECOND_LIST_INTEGRITY_CHECK_VALUE}
	{$define listSET_FIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem )
	{$define listSET_SECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem )
	{$define listSET_LIST_INTEGRITY_CHECK_1_VALUE( pxList )
	{$define listSET_LIST_INTEGRITY_CHECK_2_VALUE( pxList )
	{$define listTEST_LIST_ITEM_INTEGRITY( pxItem )
	{$define listTEST_LIST_INTEGRITY( pxList )
{$else}
	(* Define macros that add new members into the list structures. *)
	{$define listFIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE				TickType_t xListItemIntegrityValue1;
	{$define listSECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE				TickType_t xListItemIntegrityValue2;
	{$define listFIRST_LIST_INTEGRITY_CHECK_VALUE					TickType_t xListIntegrityValue1;
	{$define listSECOND_LIST_INTEGRITY_CHECK_VALUE					TickType_t xListIntegrityValue2;

	(* Define macros that set the new structure members to known values. *)
	#define listSET_FIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem )		( pxItem )->xListItemIntegrityValue1 = pdINTEGRITY_CHECK_VALUE
	#define listSET_SECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem )	( pxItem )->xListItemIntegrityValue2 = pdINTEGRITY_CHECK_VALUE
	#define listSET_LIST_INTEGRITY_CHECK_1_VALUE( pxList )		( pxList )->xListIntegrityValue1 = pdINTEGRITY_CHECK_VALUE
	#define listSET_LIST_INTEGRITY_CHECK_2_VALUE( pxList )		( pxList )->xListIntegrityValue2 = pdINTEGRITY_CHECK_VALUE

	(* Define macros that will assert if one of the structure members does not
	contain its expected value. *)
	#define listTEST_LIST_ITEM_INTEGRITY( pxItem )		configASSERT( ( ( pxItem )->xListItemIntegrityValue1 =  pdINTEGRITY_CHECK_VALUE ) && ( ( pxItem )->xListItemIntegrityValue2 =  pdINTEGRITY_CHECK_VALUE ) )
	#define listTEST_LIST_INTEGRITY( pxList )			configASSERT( ( ( pxList )->xListIntegrityValue1 =  pdINTEGRITY_CHECK_VALUE ) && ( ( pxList )->xListIntegrityValue2 =  pdINTEGRITY_CHECK_VALUE ) )
{$endif} (* configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES *)
*)

type
//struct xLIST_ITEM
  // Removed  references, FPC doesn't require volatile anyway
  PListItem = ^TListItem_t;
  TListItem_t = record
  {$if defined(configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES) and (configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES = 1)}
	  xListItemIntegrityValue1: TTickType;
  {$endif}
	  xItemValue: TTickType;
	  pxNext: PListItem;
	  pxPrevious: PListItem;
	  pvOwner: pointer;
	  pvContainer: pointer;
  {$if defined(configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES) and (configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES = 1)}
	  xListItemIntegrityValue2: TTickType;
  {$endif}
  end;

//struct xMINI_LIST_ITEM
  TMiniListItem = record
  {$if defined(configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES) and (configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES = 1)}
  xListItemIntegrityValue1: TTickType;
  {$endif}
    xItemValue: TTickType;
	  pxNext: PListItem;
	  pxPrevious: PListItem;
  end;

  PList = ^TList;
//struct xLIST
  TList = record
    {$if defined(configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES) and (configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES = 1)}
    xListItemIntegrityValue1: TTickType;
    {$endif}
	  uxNumberOfItems: TUBaseType;
	  pxIndex: PListItem;
	  xListEnd: TMiniListItem;
    {$if defined(configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES) and (configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES = 1)}
    xListItemIntegrityValue2: TTickType;
    {$endif}
  end ;

(* Not sure these macros needs to be translated to FPC
#define listSET_LIST_ITEM_OWNER( pxListItem, pxOwner )		( ( pxListItem )->pvOwner = ( void * ) ( pxOwner ) )
#define listGET_LIST_ITEM_OWNER( pxListItem )	( ( pxListItem )->pvOwner )
#define listSET_LIST_ITEM_VALUE( pxListItem, xValue )	( ( pxListItem )->xItemValue = ( xValue ) )
#define listGET_LIST_ITEM_VALUE( pxListItem )	( ( pxListItem )->xItemValue )
#define listGET_ITEM_VALUE_OF_HEAD_ENTRY( pxList )	( ( ( pxList )->xListEnd ).pxNext->xItemValue )
#define listGET_HEAD_ENTRY( pxList )	( ( ( pxList )->xListEnd ).pxNext )
#define listGET_NEXT( pxListItem )	( ( pxListItem )->pxNext )
#define listGET_END_MARKER( pxList )	( ( ListItem_t const * ) ( &( ( pxList )->xListEnd ) ) )
#define listLIST_IS_EMPTY( pxList )	( ( BaseType_t ) ( ( pxList )->uxNumberOfItems =  ( UBaseType_t ) 0 ) )
#define listCURRENT_LIST_LENGTH( pxList )	( ( pxList )->uxNumberOfItems )
#define listGET_OWNER_OF_NEXT_ENTRY( pxTCB, pxList )										\
{																							\
List_t * const pxConstList = ( pxList );													\
	(* Increment the index to the next item and return the item, ensuring *)				\
	(* we don't return the marker used at the end of the list.  *)							\
	( pxConstList )->pxIndex = ( pxConstList )->pxIndex->pxNext;							\
	if( ( void * ) ( pxConstList )->pxIndex =  ( void * ) &( ( pxConstList )->xListEnd ) )	\
	{																						\
		( pxConstList )->pxIndex = ( pxConstList )->pxIndex->pxNext;						\
	}																						\
	( pxTCB ) = ( pxConstList )->pxIndex->pvOwner;											\
}

#define listGET_OWNER_OF_HEAD_ENTRY( pxList )  ( (&( ( pxList )->xListEnd ))->pxNext->pvOwner )
#define listIS_CONTAINED_WITHIN( pxList, pxListItem ) ( ( BaseType_t ) ( ( pxListItem )->pvContainer =  ( void * ) ( pxList ) ) )
#define listLIST_ITEM_CONTAINER( pxListItem ) ( ( pxListItem )->pvContainer )
#define listLIST_IS_INITIALISED( pxList ) ( ( pxList )->xListEnd.xItemValue =  portMAX_DELAY )
*)

procedure vListInitialise(pxList: PList); external;

procedure vListInitialiseItem(pxItem: PListItem); external;
procedure vListInsert(pxList: PList; pxNewListItem: PListItem); external;

procedure vListInsertEnd(pxList: PList; pxNewListItem: PListItem); external;
function uxListRemove(pxItemToRemove: PListItem): TUBaseType; external;


implementation

end.

