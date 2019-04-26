{if $menu.items|@count > 0}
{if !$mobile_device}

    <!-- MODULE JBX_MENU -->
        <a id="header_logo" href="{$base_dir}" title="{$shop_name|escape:'htmlall':'UTF-8'}">
          <img class="logo" src="{$img_ps_dir}logo.jpg?{$img_update_time}" alt="{$shop_name|escape:'htmlall':'UTF-8'}" {if $logo_image_width}width="{$logo_image_width}"{/if} {if $logo_image_height}height="{$logo_image_height}" {/if} />
        </a>
    <div class="sf-contener">
        <ul class="sf-menu">
          {foreach from=$menu.items item=item name=menuTree}
              {include file=$menu_tpl_tree}
          {/foreach}
          {* <li><a href="{$link->getPageLink('contact-form.php', true)}" title="{l s='Contact' mod='jbx_menu'}">{l s='Contact' mod='jbx_menu'}</a></li> *}
                {if $cookie->isLogged()}
                    <li><a href="{$link->getPageLink('index.php')}?mylogout" title="{l s='B2B logout' mod='jbx_menu'}">{l s='B2B logout' mod='jbx_menu'}</a>
                        <ul class="bblogin">
                    <li>
                        <a href="{$link->getPageLink('my-account.php')}" title="{l s='My account' mod='jbx_menu'}">
                            &nbsp;{l s='My account' mod='jbx_menu'}
                        </a>
                    </li>
                </ul>
                    </li>
                {else}
                    <li><a href="{$link->getPageLink('my-account.php', true)}" title="{l s='B2B login' mod='jbx_menu'}">{l s='B2B login' mod='jbx_menu'}</a></li>
                {/if}
            <li><a href="{$link->getPageLink('order.php', true)}" title="{l s='View Basket' mod='jbx_menu'}">{l s='View Basket' mod='jbx_menu'}</a></li>
            
			
            {if !$PS_CATALOG_MODE}
				<b>
                <span class="ajax_cart_quantity{if $cart_qties == 0} hidden{/if}">{$cart_qties}</span>
                <span class="ajax_cart_product_txt{if $cart_qties != 1} hidden{/if}">&nbsp;{l s='Pcs. - ' mod='jbx_menu'}&nbsp;</span>
                <span class="ajax_cart_product_txt_s{if $cart_qties < 2} hidden{/if}">&nbsp;{l s='Pcs. - ' mod='jbx_menu'}&nbsp;</span>
                {if $cart_qties >= 0}
                    <span class="ajax_cart_total{if $cart_qties == 0} hidden{/if}">
                        {if $priceDisplay == 1}
                            {assign var='blockuser_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
                            {convertPrice price=$cart->getOrderTotal(false, $blockuser_cart_flag)}
                            {* $cart->getOrderTotal(false, $blockuser_cart_flag)|number_format:0:".":"," *}
                        {else}
                            {assign var='blockuser_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
                            {convertPrice price=$cart->getOrderTotal(false, $blockuser_cart_flag)}
                            {* $cart->getOrderTotal(false, $blockuser_cart_flag)|number_format:0:".":"," *}
                        {/if}
                        <div class="boxcurr" >
                        {foreach from=$currencies key=k item=f_currency}
                        	
                                <div {if $cookie->id_currency == $f_currency.id_currency}class="selected"{/if}>
                                    <a href="javascript:setCurrency({$f_currency.id_currency});" title="{$f_currency.name}">{$f_currency.sign}</a>
                                </div>
                            
                        {/foreach}
                        </div>
                    </span>
                {/if}
                <span class="ajax_cart_no_product{if $cart_qties > 0} hidden{/if}"><span>{l s='0 Pcs. - ' mod='jbx_menu'}&nbsp;</span>
                	<span class="ajax_cart_total"> {convertPrice price=0}
                    <div class="boxcurr" >
                        {foreach from=$currencies key=k item=f_currency}
                        	
                                <div {if $cookie->id_currency == $f_currency.id_currency}class="selected"{/if}>
                                    <a href="javascript:setCurrency({$f_currency.id_currency});" title="{$f_currency.name}">{$f_currency.sign}</a>
                                </div>
                            
                        {/foreach}
                        </div>
                	</span>
                </span>
				</b>
            {/if}
</a>
          
          {if $menu.searchable_active}
          <li class="sf-search noBack" style="float:right">
              <form id="searchbox" action="search.php" method="get">
                  <input type="hidden" value="position" name="orderby" />
                  <input type="hidden" value="desc" name="orderway" />
                  <input type="text" name="search_query" id="search_query_menu" class="search" value="{if isset($smarty.get.search_query)}{$smarty.get.search_query}{/if}" autocomplete="off" />
                  {if $menu.searchable_button}
                      <input type="submit" value="ok" class="search_button" />
                  {/if}
              </form>
          </li>
          {/if}
        </ul>
        </div>
        <!-- /MODULE JBX_MENU -->
    
  {else}
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
  <script src="https://unpkg.com/popper.js/dist/umd/popper.min.js"></script>
<nav class="navbar navbar-inverse" id="topNav">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#myNavbar" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a id="header_logo" href="{$base_dir}" title="{$shop_name|escape:'htmlall':'UTF-8'}">
          <img class="logo" src="{$img_ps_dir}logo.jpg?{$img_update_time}" alt="{$shop_name|escape:'htmlall':'UTF-8'}" {if $logo_image_width}width="{$logo_image_width}"{/if} {if $logo_image_height}height="{$logo_image_height}" {/if} />
      </a>
      <div class="container1">
    <form method="get" action="{$base_dir}search" id="searchbox3">
      <input type="text" id="search_query_top_new" name="search_query" placeholder="Search" onfocus="javascript:if(this.value=='Search...')this.value='';" onblur="javascript:if(this.value=='')this.value='Search...';">
      <div class="search"></div>
    </form>
  </div>
      <div class="cart_header">
        <span class="ajax_cart_quantity{if $cart_qties == 0} hidden{/if}"><a href="{$link->getPageLink('order.php', true)}"/>{$cart_qties}</a></span>
                 <a href="{$link->getPageLink('order.php', true)}"/><span class="ajax_cart_product_txt{if $cart_qties != 1} hidden{/if}">&nbsp;{l s='PCS' mod='jbx_menu'}&nbsp;</span></a>
                <a href="{$link->getPageLink('order.php', true)}"/><span class="ajax_cart_product_txt_s{if $cart_qties < 2} hidden{/if}">&nbsp;{l s='PCS' mod='jbx_menu'}&nbsp;</span></a>       
                <span class="ajax_cart_no_product{if $cart_qties > 0} hidden{/if}"><span>{l s='0 PCS' mod='jbx_menu'}&nbsp;</span>
      </div>
<!--         <div class="col-md-4 col-md-offset-3">
            <form method="get" action="https://headzone.bendata.dk/search" id="searchbox" class="search">
              <div class="search__wrapper">
                <input class="search__field" type="text" id="search_query_top" name="search_query" placeholder="Search" onfocus="javascript:if(this.value=='Search...')this.value='';" onblur="javascript:if(this.value=='')this.value='Search...';">

                <button type="submit" class="fa fa-search search__icon" class="vishide" name="submit_search"><img src="https://netto-dk-prod.azureedge.net/images/icons/search-white.svg" class="iconnew"></button>
              </div>
            </form>
        </div> -->
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav w3-animate-left">
        <li class="dropdown">
            {foreach from=$menu.items item=item name=menuTree}
              <li class="dropdown">
              <a href="{$item.link}" {if !empty($item.childrens)}class="dropdown-toggle" data-toggle="dropdown"{/if}>{$item.title}
                <span class="caret"></span></a>
                  {if !empty($item.childrens)}
                  <ul class="dropdown-menu">
                    {foreach from=$item.childrens item=child}                  
                    <li><a href="{$child.link}">{$child.title}</a></li>
                    {/foreach}
                  </ul>
                  {/if}
              </li>
            {/foreach}
        </li>
      {if $cookie->isLogged()}
          <li><a href="{$link->getPageLink('index.php')}?mylogout" title="{l s='B2B logout' mod='jbx_menu'}">{l s='B2B logout' mod='jbx_menu'}
              </a>
                <ul class="bblogin">
                  <li>
                      <a href="{$link->getPageLink('my-account.php')}" title="{l s='My account' mod='jbx_menu'}">
                          &nbsp;{l s='My account' mod='jbx_menu'}
                      </a>
                  </li>
                </ul>
          </li>
      {else}
          <li>
            <a href="{$link->getPageLink('my-account.php', true)}" title="{l s='B2B login' mod='jbx_menu'}">{l s='B2B login' mod='jbx_menu'}</a>
          </li>
      {/if}
        <li>
          <a href="{$link->getPageLink('order.php', true)}" title="{l s='View Basket' mod='jbx_menu'}">{l s='View Basket' mod='jbx_menu'}</a>
        </li>

         {if !$PS_CATALOG_MODE}
            <li class="cartajaxquantity">
                <span class="ajax_cart_quantity{if $cart_qties == 0} hidden{/if}">{$cart_qties}</span>
                <span class="ajax_cart_product_txt{if $cart_qties != 1} hidden{/if}">&nbsp;{l s='Pcs. - ' mod='jbx_menu'}&nbsp;</span>
                <span class="ajax_cart_product_txt_s{if $cart_qties < 2} hidden{/if}">&nbsp;{l s='Pcs. - ' mod='jbx_menu'}&nbsp;</span>
                {if $cart_qties >= 0}
                    <span class="ajax_cart_total{if $cart_qties == 0} hidden{/if}">
                        {if $priceDisplay == 1}
                            {assign var='blockuser_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
                            {convertPrice price=$cart->getOrderTotal(false, $blockuser_cart_flag)}
                            {* $cart->getOrderTotal(false, $blockuser_cart_flag)|number_format:0:".":"," *}
                        {else}
                            {assign var='blockuser_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
                            {convertPrice price=$cart->getOrderTotal(false, $blockuser_cart_flag)}
                            {* $cart->getOrderTotal(false, $blockuser_cart_flag)|number_format:0:".":"," *}
                        {/if}
                          <div>
                            {foreach from=$currencies key=k item=f_currency}
                              
                                <div {if $cookie->id_currency == $f_currency.id_currency}class="selected"{/if}>
                                    <a href="javascript:setCurrency({$f_currency.id_currency});" title="{$f_currency.name}">{$f_currency.sign}</a>
                                </div>
                                
                            {/foreach}
                          </div>
                    </span>
                {/if}
                <span class="ajax_cart_no_product{if $cart_qties > 0} hidden{/if}"><span style="color: white;">{l s='0 Pcs. - ' mod='jbx_menu'}&nbsp;</span>
                  <span class="ajax_cart_total" style="color: white"> {convertPrice price=0}
                       <div>
                            {foreach from=$currencies key=k item=f_currency}
                              
                                <div {if $cookie->id_currency == $f_currency.id_currency}class="selected"{/if}>
                                    <a href="javascript:setCurrency({$f_currency.id_currency});" title="{$f_currency.name}">{$f_currency.sign}</a>
                                </div>
                                
                            {/foreach}
                        </div>
                  </span>
                </span>
            </li>
        {/if}
      </ul>
    </div>
  </div>
</nav>
  {/if}
{/if}

<script type="text/javascript">
	$(document).ready(function() {
		/*$(".ajax_cart_total").click(function () { 
		  $(".boxcurr").toggle('slow'); 
		});*/
		
		/*$(".ajax_cart_total").mouseover(function () { 
		  //$(".boxcurr").toggle('slow'); 
		  $(".boxcurr").css('display','block');
		});
		
		$(".ajax_cart_total").mouseout(function () { 
		  //$(".boxcurr").toggle('slow'); 
		  $(".boxcurr").css('display','none');
		});*/
    var split = 0;
    var modified_menu = '<ul>';
    $('.sf-menu li:first ul li').each(function(i, item){        
        modified_menu += '<li>'+$(item).html()+'</li>';
        if ((i+1) == {$jbx_menu_split1} || (i+1) == {$jbx_menu_split2}) {
          split++;
          modified_menu += '</ul><ul class="sec-ul menu-ul-split-'+split+'">';
        }
    });
    modified_menu += '</ul>';
    $('.sf-menu li:first ul').replaceWith(modified_menu);

    $('.sf-menu li:first').hover(function() {
      $('.sf-menu li:first ul').matchHeight();
    });

	});
</script>
