package com.appdynamics;

import com.appdynamics.instrumentation.sdk.Rule;
import com.appdynamics.instrumentation.sdk.SDKClassMatchType;
import com.appdynamics.instrumentation.sdk.SDKStringMatchType;
import com.appdynamics.instrumentation.sdk.contexts.ISDKUserContext;
import com.appdynamics.instrumentation.sdk.template.AEntry;
import com.appdynamics.instrumentation.sdk.toolbox.reflection.IReflector;
import com.appdynamics.instrumentation.sdk.toolbox.reflection.ReflectorException;

import java.util.ArrayList;
import java.util.List;

public class JAXWSEntry extends AEntry {

    private IReflector getMessage = null;
    private IReflector getHeaders = null;
    private IReflector getStringContent = null;
    private IReflector getLocalPart = null;
    private IReflector streamDelegate = null;
    private IReflector getPayloadLocalPart = null;

    public JAXWSEntry (){
        super();
        getMessage = getNewReflectionBuilder()
                .invokeInstanceMethod("getMessage", true)
                .build();

        streamDelegate = getNewReflectionBuilder()
                .accessFieldValue("streamDelegate", true)
                .build();

        getHeaders= getNewReflectionBuilder()
                .invokeInstanceMethod("getHeaders", true)
                .build();

        getLocalPart = getNewReflectionBuilder()
                .invokeInstanceMethod("getLocalPart", true)
                .build();

        getStringContent = getNewReflectionBuilder()
                .invokeInstanceMethod("getStringContent", true)
                .build();

        getPayloadLocalPart = getNewReflectionBuilder()
                .invokeInstanceMethod("getPayloadLocalPart", true)
                .build();

    }

    @Override
    public List<Rule> initializeRules() {

        List<Rule> rules = new ArrayList<Rule>();

        Rule.Builder bldr = new Rule.Builder("com.sun.xml.ws.server.InvokerTube");
        bldr = bldr.classMatchType(SDKClassMatchType.MATCHES_CLASS).classStringMatchType(SDKStringMatchType.STARTSWITH);
        bldr = bldr.methodMatchString("invoke").methodStringMatchType(SDKStringMatchType.EQUALS);
        rules.add(bldr.build());

        return rules;
    }

    @Override
    public String unmarshalTransactionContext(Object o, String s, String s1, Object[] objects, ISDKUserContext isdkUserContext) throws ReflectorException {
        Object servletRequest = objects[0];
        getLogger().debug("The " + servletRequest.getClass().getSimpleName());
        try{

            if(servletRequest!=null) {
                if(servletRequest.getClass().getSimpleName().equals("Packet")) {
                    Object in = this.getMessage.execute(servletRequest.getClass().getClassLoader(), servletRequest);
                    Object streamDelegateMessage = this.streamDelegate.execute(in.getClass().getClassLoader(), in);
                    java.util.ArrayList headers = (java.util.ArrayList)this.getHeaders.execute(streamDelegateMessage.getClass().getClassLoader(), streamDelegateMessage);

                    getLogger().debug("The " + headers);
                    for (Object a : headers){
                        Object localPart = this.getLocalPart.execute(a.getClass().getClassLoader(), a);
                        getLogger().debug("The " + localPart);

                        if(localPart.equals("singularityheader")) {
                            String test = this.getStringContent.execute(a.getClass().getClassLoader(), a);
                            getLogger().debug("The " + test);

                            return test;
                        }
                    }
                }
            }
        }
        catch(Exception e){

        }
        return "";
    }

    @Override
    public String getBusinessTransactionName(Object o, String s, String s1, Object[] objects, ISDKUserContext isdkUserContext) throws ReflectorException {

        Object servletRequest = objects[0];
        try{
            if(servletRequest!=null) {
                if(servletRequest.getClass().getSimpleName().equals("Packet")) {
                    Object in = this.getMessage.execute(servletRequest.getClass().getClassLoader(), servletRequest);
                    Object streamDelegateMessage = this.streamDelegate.execute(in.getClass().getClassLoader(), in);
                    return this.getPayloadLocalPart.execute(streamDelegateMessage.getClass().getClassLoader(), streamDelegateMessage);
                }
            }
        }
        catch(Exception e){

        }


        return "Default Name - com.sun.xml.ws.server.InvokerTube";
    }

    @Override
    public boolean isCorrelationEnabled() {
        return true;
    }

    @Override
    public boolean isCorrelationEnabledForOnMethodBegin() {
        return true;
    }





}
