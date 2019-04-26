{include file="$tpl_dir./errors.tpl"}
{if $errors|@count == 0}
<script type="text/javascript">
// <![CDATA[

// PrestaShop internal settings
var currencySign = '{$currencySign|html_entity_decode:2:"UTF-8"}';
var currencyRate = '{$currencyRate|floatval}';
var currencyFormat = '{$currencyFormat|intval}';
var currencyBlank = '{$currencyBlank|intval}';
var taxRate = {$tax_rate|floatval};
var jqZoomEnabled = {if $jqZoomEnabled}true{else}false{/if};

//JS Hook
var oosHookJsCodeFunctions = new Array();

// Parameters
var id_product = '{$product->id|intval}';
var productHasAttributes = {if isset($groups)}true{else}false{/if};
var quantitiesDisplayAllowed = {if $display_qties == 1}true{else}false{/if};
var quantityAvailable = {if $display_qties == 1 && $product->quantity}{$product->quantity}{else}0{/if};
var allowBuyWhenOutOfStock = {if $allow_oosp == 1}true{else}false{/if};
var availableNowValue = '{$product->available_now|escape:'quotes':'UTF-8'}';
var availableLaterValue = '{$product->available_later|escape:'quotes':'UTF-8'}';
var productPriceTaxExcluded = {$product->getPriceWithoutReduct(true)|default:'null'} - {$product->ecotax};
var reduction_percent = {if $product->specificPrice AND $product->specificPrice.reduction AND $product->specificPrice.reduction_type == 'percentage'}{$product->specificPrice.reduction*100}{else}0{/if};
var reduction_price = {if $product->specificPrice AND $product->specificPrice.reduction AND $product->specificPrice.reduction_type == 'amount'}{$product->specificPrice.reduction}{else}0{/if};
var specific_price = {if $product->specificPrice AND $product->specificPrice.price}{$product->specificPrice.price}{else}0{/if};
var specific_currency = {if $product->specificPrice AND $product->specificPrice.id_currency}true{else}false{/if};
var group_reduction = '{$group_reduction}';
var default_eco_tax = {$product->ecotax};
var ecotaxTax_rate = {$ecotaxTax_rate};
var currentDate = '{$smarty.now|date_format:'%Y-%m-%d %H:%M:%S'}';
var maxQuantityToAllowDisplayOfLastQuantityMessage = {$last_qties};
var noTaxForThisProduct = {if $no_tax == 1}true{else}false{/if};
var displayPrice = {$priceDisplay};
var productReference = '{$product->reference|escape:'htmlall':'UTF-8'}';
var productAvailableForOrder = {if (isset($restricted_country_mode) AND $restricted_country_mode) OR $PS_CATALOG_MODE}'0'{else}'{$product->available_for_order}'{/if};
var productShowPrice = '{if !$PS_CATALOG_MODE}{$product->show_price}{else}0{/if}';
var productUnitPriceRatio = '{$product->unit_price_ratio}';
var idDefaultImage = {if isset($cover.id_image_only)}{$cover.id_image_only}{else}0{/if};

// Customizable field
var img_ps_dir = '{$img_ps_dir}';
var customizationFields = new Array();
{assign var='imgIndex' value=0}
{assign var='textFieldIndex' value=0}
{foreach from=$customizationFields item='field' name='customizationFields'}
	{assign var="key" value="pictures_`$product->id`_`$field.id_customization_field`"}
	customizationFields[{$smarty.foreach.customizationFields.index|intval}] = new Array();
	customizationFields[{$smarty.foreach.customizationFields.index|intval}][0] = '{if $field.type|intval == 0}img{$imgIndex++}{else}textField{$textFieldIndex++}{/if}';
	customizationFields[{$smarty.foreach.customizationFields.index|intval}][1] = {if $field.type|intval == 0 && isset($pictures.$key) && $pictures.$key}2{else}{$field.required|intval}{/if};
{/foreach}

// Images
var img_prod_dir = '{$img_prod_dir}';
var combinationImages = new Array();

{if isset($combinationImages)}
	{foreach from=$combinationImages item='combination' key='combinationId' name='f_combinationImages'}
		combinationImages[{$combinationId}] = new Array();
		{foreach from=$combination item='image' name='f_combinationImage'}
			combinationImages[{$combinationId}][{$smarty.foreach.f_combinationImage.index}] = {$image.id_image|intval};
		{/foreach}
	{/foreach}
{/if}

combinationImages[0] = new Array();
{if isset($images)}
	{foreach from=$images item='image' name='f_defaultImages'}
		combinationImages[0][{$smarty.foreach.f_defaultImages.index}] = {$image.id_image};
	{/foreach}
{/if}

// Translations
var doesntExist = '{l s='The product does not exist in this model. Please choose another.' js=1}';
var doesntExistNoMore = '{l s='This product is no longer in stock' js=1}';
var doesntExistNoMoreBut = '{l s='with those attributes but is available with others' js=1}';
var uploading_in_progress = '{l s='Uploading in progress, please wait...' js=1}';
var fieldRequired = '{l s='Please fill in all required fields, then save the customization.' js=1}';

{if isset($groups)}
	// Combinations
	{foreach from=$combinations key=idCombination item=combination}
		addCombination({$idCombination|intval}, new Array({$combination.list}), {$combination.quantity}, {$combination.price}, {$combination.ecotax}, {$combination.id_image}, '{$combination.reference|addslashes}', {$combination.unit_impact}, {$combination.minimal_quantity});
	{/foreach}
	// Colors
	{if $colors|@count > 0}
		{if $product->id_color_default}var id_color_default = {$product->id_color_default|intval};{/if}
	{/if}
{/if}


function newsomeqty($id_attribute){
	var nsumoty = parseFloat(0);
	var nsumprice = parseFloat(0);
	var prprice = parseFloat({$productgetprice});
	{foreach from=$listsize item=listsizex name=listsizex}
		//quantity_{$listsizex.id_attribute};
		//console.log($("#quantity_{$listsizex.id_attribute}").val());
		if($("#quantity_{$listsizex.id_attribute}").val() >= 1 ){
			var idattp = parseFloat($("#quantity_{$listsizex.id_attribute}").val());
		}
		else
		{
			var idattp = 0;
		}
		var maxatt = parseFloat($("#attmax_{$listsizex.id_attribute}").val());
		var attpricr = parseFloat($("#attprice_{$listsizex.id_attribute}").val());
		
		var atptax = ({$tax_rate}+100)/100;
		
		if(idattp > maxatt){
			$("#winningpro").html("product size {$listsizex.name} has "+ maxatt);
			idattp = maxatt;
			$("#quantity_{$listsizex.id_attribute}").val(idattp);
		}
		nsumprice = nsumprice + ((prprice + (attpricr*atptax)) * idattp);
		nsumoty = nsumoty + idattp;
	{/foreach}
	
	$("#quantity_all").val(nsumoty);
	//$("#pro_allprice").val(nsumprice.toFixed(2));
	//$("#pro_allprice").val({$productgetprice});
	
}
//]]>

function prepareOrder() {
		console.log(orderSet);
}

</script>

{foreach from=$colors key='id_attribute' item='color'}
			{if $cover.id_image_only == $color.id_img}
                {if $select_image && $select_attribute}
                    {assign var='idcolorcx' value=$select_image}
                    {assign var='idattcx' value=$select_attribute}
                {else}
                    {assign var='idcolorcx' value=$color.id_img}
                    {assign var='idattcx' value=$id_attribute}
                {/if}
            {/if}
            
			
{/foreach}
<script type="text/javascript">
		{literal}
		
		function updateColor($id_attribute,$id_image){
			$("#attributes").slideUp();
			var colortitle = $('#color_'+$id_attribute).attr("title");
			//alert(colortitle);
			$("#pb-left-column h1 span").html(colortitle);
			
			var id_image = $id_image;
			var id_attribute = $id_attribute;
			if(id_image){
				//$("#image-block").fadeOut("fast");
				$.ajax({
					url: '{/literal}{$base_dir_ssl}{literal}advancepro.php',
					type: 'POST',
					data: 'id_image='+id_image+'&action=getimg&id_product={/literal}{$product->id}{literal}',
					success: function( data )
					{
						if( data != "" )
						{
							//$("#image-block").fadeIn("slow");
							$("#image-block").html(data);
							{/literal}{if $cookie->isLogged()}{literal}
								getattribute($id_attribute);
							{/literal}{/if}{literal}
						}
					}
				});
			}else if(id_attribute)
			{
				//$("#image-block").fadeIn("slow");
				$("#image-block").html("<img src='{/literal}{$base_dir_ssl}{literal}img/p/en-default-large.jpg' id='bigpic' width='653' height='480' />");
				{/literal}{if $cookie->isLogged()}{literal}
					getattribute($id_attribute);
				{/literal}{/if}{literal}
			}
		}	
		
		function getattribute($id_attribute){
			var id_attribute = $id_attribute;
			$.ajax({
				url: '{/literal}{$base_dir_ssl}{literal}advancepro.php',
				type: 'POST',
				data: 'id_product='+id_product+'&id_attribute='+id_attribute+'&action=getattribute',
				success: function( data )
				{
					if( data != "" )
					{
						$("#attributes").slideDown();
						$("#attributes").html(data);
					}
				}
			});
		}
		{/literal}
	</script>
	
	
	
<div id="primary_block" class="clearfix productpage">

	{if isset($adminActionDisplay) && $adminActionDisplay}
	<div id="admin-action">
		<p>{l s='This product is not visible to your customers.'}
		<input type="hidden" id="admin-action-product-id" value="{$product->id}"  />
		<input type="submit" value="{l s='Publish'}" class="exclusive" onclick="submitPublishProduct('{$base_dir_ssl}{$smarty.get.ad}', 0)"/>
		<input type="submit" value="{l s='Back'}" class="exclusive" onclick="submitPublishProduct('{$base_dir_ssl}{$smarty.get.ad}', 1)"/>
		
		</p>
		<div class="clear" ></div>
		<p id="admin-action-result"></p>
		</p>
	</div>
	{/if}


	<!-- right infos-->
	<div id="pb-right-column">
    	{include file="$tpl_dir./breadcrumb.tpl"}
		<!-- product img-->
		<div id="image-block">
		{* {if $have_image}
			<img src="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'large')}"{if $jqZoomEnabled}class="jqzoom" alt="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'thickbox')}"{else} title="{$product->name|escape:'htmlall':'UTF-8'}" alt="{$product->name|escape:'htmlall':'UTF-8'}" {/if} id="bigpic" width="{$largeSize.width}" height="{$largeSize.height}" />
		{else}
			<img src="{$img_prod_dir}{$lang_iso}-default-large.jpg" id="bigpic" alt="" title="{$product->name|escape:'htmlall':'UTF-8'}" width="{$largeSize.width}" height="{$largeSize.height}" />
		{/if} *}
		</div>
        
        &nbsp;

    </div>

	<!-- left infos-->
	<div id="pb-left-column">
    	<h1>{$product->name} <span></span></h1>
       {* <h2>{l s='Product Description'}</h2>*}
        
		{if $product->description OR $packItems|@count > 0}
		<div id="short_description_block">
			{if $product->description}
				<div id="short_description_content" class="rte align_justify">{$product->description}</div>
			{/if}
			{if $packItems|@count > 0}
				<h3>{l s='Pack content'}</h3>
				{foreach from=$packItems item=packItem}
					<div class="pack_content">
						{$packItem.pack_quantity} x <a href="{$link->getProductLink($packItem.id_product, $packItem.link_rewrite, $packItem.category)}">{$packItem.name|escape:'htmlall':'UTF-8'}</a>
						<p>{$packItem.description_short}</p>
					</div>
				{/foreach}
			{/if}
		</div>
		{/if}

		{if isset($colors) && $colors}
		<!-- colors -->
		<div id="color_picker">
			{*<h2>{l s='Colours'}</h2>*}
			<ul id="color_to_pick_list">
			{foreach from=$colors key='id_attribute' item='color'}
				<li style="{if isset($color.id_img)}background-image:url({$link->getImageLink($product->link_rewrite, $color.id_img, 'small')});{else}background-color:{$color.value};{/if}"><a id="color_{$id_attribute|intval}" class="color_pick"  onclick="updateColor({$id_attribute|intval},{if isset($color.id_img)}{$color.id_img}{else}0{/if});" title="{$color.name}">{if file_exists($col_img_dir|cat:$id_attribute|cat:'.jpg')}<img src="{$img_col_dir}{$id_attribute}.jpg" alt="{$color.name}" width="20" height="20" />{/if}</a></li>
			{/foreach}
			</ul>
			<div class="clear"></div>
             
            
            
		</div>
		{/if}

		{if ($product->show_price AND !isset($restricted_country_mode)) OR isset($groups) OR $product->reference OR (isset($HOOK_PRODUCT_ACTIONS) && $HOOK_PRODUCT_ACTIONS)}
		<!-- add to cart form-->
		<form id="buy_block" {if $PS_CATALOG_MODE AND !isset($groups) AND $product->quantity > 0}class="hidden"{/if} action="{$link->getPageLink('cart.php')}" method="post">

			<!-- hidden datas -->
			<p class="hidden">
				<input type="hidden" name="token" value="{$static_token}" />
				<input type="hidden" name="id_product" value="{$product->id|intval}" id="product_page_product_id" />
				<input type="hidden" name="add" value="1" />
				<input type="hidden" name="id_product_attribute" value="" id="idCombination"/>
			</p>
            
            <div style="clear:both; height:0px;">
            {*
            {if $cookie->isLogged()}
            <div id="pricepro"><h2>{l s='Product Price : '}<span>{convertPrice price=$productgetprice}</span></h2></div>
            {/if}
            *}
			<div id="winningpro"></div>
            {if isset($groups)}
			<!-- attributes -->
			<div id="attributes"></div>
			{/if}
        </div>
            
            
			{if isset($HOOK_PRODUCT_ACTIONS) && $HOOK_PRODUCT_ACTIONS}{$HOOK_PRODUCT_ACTIONS}{/if}
			<div class="clear"></div>
		</form>
		{/if}
		{if $HOOK_EXTRA_RIGHT}{$HOOK_EXTRA_RIGHT}{/if}
	</div>
</div>

{if $quantity_discounts}
<!-- quantity discount -->
<ul class="idTabs">
	<li><a style="cursor: pointer" class="selected">{l s='Quantity discount'}</a></li>
</ul>
<div id="quantityDiscount">
	<table class="std">
		<tr>
			{foreach from=$quantity_discounts item='quantity_discount' name='quantity_discounts'}
				<th>{$quantity_discount.quantity|intval}
				{if $quantity_discount.quantity|intval > 1}
					{l s='quantities'}
				{else}
					{l s='quantity'}
				{/if}
				</th>
			{/foreach}
		</tr>
		<tr>
			{foreach from=$quantity_discounts item='quantity_discount' name='quantity_discounts'}
				<td>
				{if $quantity_discount.price != 0 OR $quantity_discount.reduction_type == 'amount'}
					-{convertPrice price=$quantity_discount.real_value|floatval}
				{else}
    				-{$quantity_discount.real_value|floatval}%
				{/if}
				</td>
			{/foreach}
		</tr>
	</table>
</div>
{/if}

{$HOOK_PRODUCT_FOOTER}

<!-- description and features -->


<!-- Customizable products -->
{if $product->customizable}
	<ul class="idTabs">
		<li><a style="cursor: pointer">{l s='Product customization'}</a></li>
	</ul>
	<div class="customization_block">
		<form method="post" action="{$customizationFormTarget}" enctype="multipart/form-data" id="customizationForm">
			<p>
				<img src="{$img_dir}icon/infos.gif" alt="Informations" />
				{l s='After saving your customized product, remember to add it to your cart.'}
				{if $product->uploadable_files}<br />{l s='Allowed file formats are: GIF, JPG, PNG'}{/if}
			</p>
			{if $product->uploadable_files|intval}
			<h2>{l s='Pictures'}</h2>
			<ul id="uploadable_files">
				{counter start=0 assign='customizationField'}
				{foreach from=$customizationFields item='field' name='customizationFields'}
					{if $field.type == 0}
						<li class="customizationUploadLine{if $field.required} required{/if}">{assign var='key' value='pictures_'|cat:$product->id|cat:'_'|cat:$field.id_customization_field}
							{if isset($pictures.$key)}<div class="customizationUploadBrowse">
									<img src="{$pic_dir}{$pictures.$key}_small" alt="" />
									<a href="{$link->getProductDeletePictureLink($product, $field.id_customization_field)}" title="{l s='Delete'}" >
										<img src="{$img_dir}icon/delete.gif" alt="{l s='Delete'}" class="customization_delete_icon" width="11" height="13" />
									</a>
								</div>{/if}
							<div class="customizationUploadBrowse"><input type="file" name="file{$field.id_customization_field}" id="img{$customizationField}" class="customization_block_input {if isset($pictures.$key)}filled{/if}" />{if $field.required}<sup>*</sup>{/if}
							<div class="customizationUploadBrowseDescription">{if !empty($field.name)}{$field.name}{else}{l s='Please select an image file from your hard drive'}{/if}</div></div>
						</li>
						{counter}
					{/if}
				{/foreach}
			</ul>
			{/if}
			<div class="clear"></div>
			{if $product->text_fields|intval}
			<h2>{l s='Texts'}</h2>
			<ul id="text_fields">
				{counter start=0 assign='customizationField'}
				{foreach from=$customizationFields item='field' name='customizationFields'}
					{if $field.type == 1}
						<li class="customizationUploadLine{if $field.required} required{/if}">{assign var='key' value='textFields_'|cat:$product->id|cat:'_'|cat:$field.id_customization_field}
							{if !empty($field.name)}{$field.name}{/if}{if $field.required}<sup>*</sup>{/if}<textarea type="text" name="textField{$field.id_customization_field}" id="textField{$customizationField}" rows="1" cols="40" class="customization_block_input" />{if isset($textFields.$key)}{$textFields.$key|stripslashes}{/if}</textarea>
						</li>
						{counter}
					{/if}
				{/foreach}
			</ul>
			{/if}
			<p style="clear: left;" id="customizedDatas">
				<input type="hidden" name="quantityBackup" id="quantityBackup" value="" />
				<input type="hidden" name="submitCustomizedDatas" value="1" />
				<input type="button" class="button" value="{l s='Save'}" onclick="javascript:saveCustomization()" />
				<span id="ajax-loader" style="display:none"><img src="{$img_ps_dir}loader.gif" alt="loader" /></span>
			</p>
		</form>
		<p class="clear required"><sup>*</sup> {l s='required fields'}</p>
	</div>
{/if}

{if $packItems|@count > 0}
	<div>
		<h2>{l s='Pack content'}</h2>
		{include file="$tpl_dir./product-list.tpl" products=$packItems}
	</div>
{/if}

{/if}

<script type="text/javascript">
		{literal}
		
		$(document).ready(function() {
			$("#attributes").slideUp();
			var id_image = '{/literal}{$idcolorcx}{literal}';
			var id_attribute = '{/literal}{$idattcx}{literal}';
			
			var colortitle = $('#color_'+id_attribute).attr("title");
			//alert(colortitle);
			$("#pb-left-column h1 span").html(colortitle);
			//var id_image = 37;
			//var id_attribute = 14;
			
			if(id_image){
				$("#image-block").fadeOut("fast");
				$.ajax({
					url: '{/literal}{$base_dir_ssl}{literal}advancepro.php',
					type: 'POST',
					data: 'id_image='+id_image+'&action=getimg&id_product={/literal}{$product->id}{literal}',
					success: function( data )
					{
						if( data != "" )
						{
							$("#image-block").fadeIn("slow");
							$("#image-block").html(data);
							{/literal}{if $cookie->isLogged()}{literal}
								getattribute(id_attribute);
							{/literal}{/if}{literal}
						}
					}
				});
			}else if(id_attribute)
			{
				$("#image-block").fadeIn("slow");
				$("#image-block").html("<img src='{/literal}{$base_dir_ssl}{literal}img/p/en-default-large.jpg' id='bigpic' width='653' height='480' />");
				{/literal}{if $cookie->isLogged()}{literal}
					getattribute(id_attribute);
				{/literal}{/if}{literal}
			}			
		});
		
		{/literal}
</script>

