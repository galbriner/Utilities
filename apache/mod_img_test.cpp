#include <httpd.h>
#include <http_protocol.h>
#include <http_config.h>
#include "util_filter.h"
#include <apr_uri.h>
#include "http_log.h"
#include  <apr_strings.h>
#include  <apr_hash.h>
#include <string>
#include <cstring>
#include <cstdarg>
#include <Magick++.h>
#include <vector>

using namespace std;

//forward declarations.
static int mod_img_test_handler(request_rec* r);
static void mod_img_register_hooks(apr_pool_t* pool);


/**
 * Declare and populate the module's data structure.  The
 * name of this structure ('infogin_module') is important - it
 * must match the name of the module.  This structure is the
 * only "glue" between the httpd core and the module.
 */
module AP_MODULE_DECLARE_DATA infogin_module = {
    STANDARD20_MODULE_STUFF,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    mod_img_register_hooks
};

/**
 * \brief This is the main Request handler for mod_infogin.
 * The main request handler. Here we will call the correct Infogin Extension function based incoming URI and other
 * considerations.
 */
static int mod_img_test_handler(request_rec* r)
{
    if ( !r->handler ) {
        return DECLINED;
    }
		vector<Magick::Image> v;
		Magick::readImages(&v, "/tmp/10k.jpg");

		v[0].modulusDepth();
		Magick::Blob b;
		Magick::writeImages(v.begin(), v.end(), &b);

		std::string sContentType("image/jpg");
    char* pContentType = static_cast<char *>(apr_palloc(r->pool, sContentType.length()+1));
    memcpy(pContentType, sContentType.c_str(), sContentType.length());
    pContentType[sContentType.length()] = '\0';
    ap_set_content_type(r, pContentType);

		ap_rwrite((const char*)b.data(), b.length(), r);


		//ap_log_rerror(APLOG_MARK, APLOG_CRIT, 0, r, "mod_img_test_handler done");

		/*std::string sContentType("text/html");
    char* pContentType = static_cast<char *>(apr_palloc(r->pool, sContentType.length()+1));
    memcpy(pContentType, sContentType.c_str(), sContentType.length());
    pContentType[sContentType.length()] = '\0';
    ap_set_content_type(r, pContentType);

    	
		std::string sMessage("<html><body>Image Test Module</body></html>");
		ap_rwrite((const char*)sMessage.c_str(), sMessage.length(), r);*/
		return OK;

    

    // Force chunked to 0. Control of headers and byte counts is left with infogin_extension
    //r->chunked = 0;

    // get the module configuration (this is the structure created by create_modig_config())
		
		return OK;//launches IG stub with the ECB.
}


/**
 * \brief This filter doesn't do anything, it just pulls data from the next filter.
 * This filter doesn't do anything, it just pulls data from the next filter.
 * I just want to make sure no other input filters run on the data.
 */
static apr_status_t InfoginPostDataFilter(ap_filter_t *f, apr_bucket_brigade *bb, ap_input_mode_t mode, apr_read_type_e block, apr_off_t readbytes)
{
    return ap_get_brigade(f->next, bb, mode, block, readbytes);
}

static apr_status_t ModInfoginChildExit(void *data)
{
	return APR_SUCCESS;
}

static void ModInfoginChildInit(apr_pool_t *p, server_rec *s)
{
	ap_log_error(APLOG_MARK, APLOG_DEBUG, 0, s, "::child_init (infogin extension)");
	apr_pool_cleanup_register(p, s, ModInfoginChildExit, ModInfoginChildExit);
}

static void mod_img_register_hooks(apr_pool_t* pool)
{
	ap_hook_handler(mod_img_test_handler, NULL, NULL, APR_HOOK_MIDDLE);
//	ap_hook_child_init(ModInfoginChildInit, NULL, NULL, APR_HOOK_MIDDLE);
//	ap_register_input_filter("Infogin", InfoginPostDataFilter, NULL, AP_FTYPE_RESOURCE);
}


